terraform {
  backend "s3" {
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.12.1"
    }

    kubectl = {
      source  = "alekc/kubectl"
      version = "2.0.4"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.25.2"
    }
  }
}

variable "cluster_state_region" {
  type = string
}

variable "cluster_state_bucket" {
  type = string
}

variable "cluster_state_key" {
  type = string
}

data "terraform_remote_state" "cluster" {
  backend = "s3"

  config = {
    endpoints = {
      s3 = "https://${var.cluster_state_region}.digitaloceanspaces.com"
    }

    bucket = var.cluster_state_bucket
    key    = var.cluster_state_key

    skip_credentials_validation = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_s3_checksum            = true
    region                      = "us-east-1"
  }
}

provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.cluster.outputs.endpoint
    token                  = data.terraform_remote_state.cluster.outputs.token
    cluster_ca_certificate = base64decode(data.terraform_remote_state.cluster.outputs.ca_certificate)
  }

  experiments {
    manifest = true
  }
}

provider "kubectl" {
  host                   = data.terraform_remote_state.cluster.outputs.endpoint
  token                  = data.terraform_remote_state.cluster.outputs.token
  cluster_ca_certificate = base64decode(data.terraform_remote_state.cluster.outputs.ca_certificate)
  load_config_file       = false
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.cluster.outputs.endpoint
  token                  = data.terraform_remote_state.cluster.outputs.token
  cluster_ca_certificate = base64decode(data.terraform_remote_state.cluster.outputs.ca_certificate)
}

variable "environment" {
  type = string
}

variable "service" {
  type    = string
  default = "runtime"
}

variable "cert_manager_acme_email" {
  type = string
}

variable "external_dns_token" {
  type      = string
  sensitive = true
}

module "runtime" {
  source = "./runtime"

  environment             = var.environment
  service                 = var.service
  cluster_name            = data.terraform_remote_state.cluster.outputs.name
  cert_manager_acme_email = var.cert_manager_acme_email
  external_dns_token      = var.external_dns_token
}
