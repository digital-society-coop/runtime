terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }

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

variable "environment" {
  type = string
}

variable "service" {
  type = string
}

variable "cluster_name" {
  type = string
}

data "digitalocean_kubernetes_cluster" "cluster" {
  name = var.cluster_name
}

resource "kubernetes_namespace" "this" {
  metadata {
    name = var.service
  }
}
