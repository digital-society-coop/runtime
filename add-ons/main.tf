terraform {
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
    region = var.cluster_state_region
    bucket = var.cluster_state_bucket
    key    = var.cluster_state_key
  }
}

provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.cluster.outputs.host
    token                  = data.terraform_remote_state.cluster.outputs.token
    cluster_ca_certificate = base64decode(data.terraform_remote_state.cluster.outputs.cluster_ca_certificate)
  }

  experiments {
    manifest = true
  }
}

provider "kubectl" {
  host                   = data.terraform_remote_state.cluster.outputs.host
  token                  = data.terraform_remote_state.cluster.outputs.token
  cluster_ca_certificate = base64decode(data.terraform_remote_state.cluster.outputs.cluster_ca_certificate)
  load_config_file       = false
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.cluster.outputs.host
  token                  = data.terraform_remote_state.cluster.outputs.token
  cluster_ca_certificate = base64decode(data.terraform_remote_state.cluster.outputs.cluster_ca_certificate)
}

variable "environment" {
  type = string
}

variable "service" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "cert_manager_acme_email" {
  type = string
}

variable "external_dns_token" {
  type      = string
  sensitive = true
}

resource "kubernetes_namespace" "this" {
  metadata {
    name = var.service
  }
}

module "runtime" {
  source = "./runtime"

  environment             = var.environment
  service                 = var.service
  cluster_name            = var.cluster_name
  cert_manager_acme_email = var.cert_manager_acme_email
  external_dns_token      = var.external_dns_token
}
