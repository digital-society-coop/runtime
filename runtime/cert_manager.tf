variable "cert_manager_acme_email" {
  type = string
}

resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  chart      = "cert-manager"
  repository = "https://charts.jetstack.io"
  version    = "v1.14.2"

  namespace       = kubernetes_namespace.this.metadata[0].name
  atomic          = true
  cleanup_on_fail = true
  reset_values    = true

  set {
    name  = "installCRDs"
    value = true
  }
}

resource "kubernetes_manifest" "cert_manager_issuer_staging" {
  manifest = yamldecode(<<-EOT
    apiVersion: cert-manager.io/v1
    kind: ClusterIssuer
    metadata:
      name: letsencrypt-staging
    spec:
      acme:
        email: ${var.cert_manager_acme_email}
        server: https://acme-staging-v02.api.letsencrypt.org/directory
        privateKeySecretRef:
          name: letsencrypt-staging-key
        solvers:
        - http01:
            ingress: {}
  EOT
  )
}

resource "kubernetes_manifest" "cert_manager_issuer_prod" {
  manifest = yamldecode(<<-EOT
    apiVersion: cert-manager.io/v1
    kind: ClusterIssuer
    metadata:
      name: letsencrypt-prod
    spec:
      acme:
        email: ${var.cert_manager_acme_email}
        server: https://acme-v02.api.letsencrypt.org/directory
        privateKeySecretRef:
          name: letsencrypt-prod-key
        solvers:
        - http01:
            ingress: {}
  EOT
  )
}
