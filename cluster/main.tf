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
  }
}

provider "digitalocean" {}

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

output "name" {
  value = digitalocean_kubernetes_cluster.this.name
}

output "endpoint" {
  value     = digitalocean_kubernetes_cluster.this.kube_config[0].endpoint
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
