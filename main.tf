terraform {
  backend "s3" {
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
  }

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.12.1"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.25.2"
    }
  }
}

provider "digitalocean" {}

provider "helm" {
  kubernetes {
    host  = digitalocean_kubernetes_cluster.this.endpoint
    token = digitalocean_kubernetes_cluster.this.kube_config[0].token
    cluster_ca_certificate = base64decode(
      digitalocean_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate
    )
  }

  experiments {
    manifest = true
  }
}

provider "kubernetes" {
  host  = digitalocean_kubernetes_cluster.this.endpoint
  token = digitalocean_kubernetes_cluster.this.kube_config[0].token
  cluster_ca_certificate = base64decode(
    digitalocean_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate
  )
}

variable "environment" {
  type = string
}

variable "service" {
  type    = string
  default = "runtime"
}

variable "region" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "kubernetes_default_node_pool_size" {
  type = string
}

variable "kubernetes_default_node_pool_node_count" {
  type = number
}

variable "external_dns_token" {
  type      = string
  sensitive = true
}

output "host" {
  value     = digitalocean_kubernetes_cluster.this.kube_config[0].host
  sensitive = true
}
output "token" {
  value     = digitalocean_kubernetes_cluster.this.kube_config[0].token
  sensitive = true
}

output "ca_certificate" {
  value     = digitalocean_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate
  sensitive = true
}

resource "digitalocean_kubernetes_cluster" "this" {
  name    = "${var.service}-${var.environment}"
  region  = var.region
  version = var.kubernetes_version

  node_pool {
    name       = "default"
    size       = var.kubernetes_default_node_pool_size
    node_count = var.kubernetes_default_node_pool_node_count
  }
}

module "runtime" {
  source = "./runtime"

  environment        = var.environment
  service            = var.service
  cluster_name       = digitalocean_kubernetes_cluster.this.name
  external_dns_token = var.external_dns_token
}
