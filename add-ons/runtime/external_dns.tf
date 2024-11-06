variable "external_dns_token" {
  type      = string
  sensitive = true
}

resource "kubernetes_secret" "external_dns_token" {
  metadata {
    generate_name = "external-dns-token-"
    namespace     = kubernetes_namespace.this.metadata[0].name
  }

  data = {
    token = var.external_dns_token
  }
}

resource "helm_release" "external_dns" {
  name       = "external-dns"
  chart      = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  version    = "1.14.3"

  namespace       = kubernetes_namespace.this.metadata[0].name
  atomic          = true
  cleanup_on_fail = true
  reset_values    = true

  set {
    name  = "policy"
    value = "sync"
  }

  set {
    name  = "txtPrefix"
    value = "runtime-${var.environment}-external-dns-"
  }

  set {
    name  = "txtOwnerId"
    value = data.digitalocean_kubernetes_cluster.cluster.id
  }

  set_list {
    name  = "sources"
    value = ["ingress"]
  }

  set {
    name  = "provider.name"
    value = "digitalocean"
  }

  values = [
    yamlencode({
      env = [
        {
          name = "DO_TOKEN"
          valueFrom = {
            secretKeyRef = {
              name = kubernetes_secret.external_dns_token.metadata[0].name
              key  = "token"
            }
          }
        }
      ]
    })
  ]
}
