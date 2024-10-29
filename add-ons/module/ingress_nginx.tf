resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  chart      = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  version    = "4.9.1"

  namespace       = kubernetes_namespace.this.metadata[0].name
  atomic          = true
  cleanup_on_fail = true
  reset_values    = true

  set {
    name  = "controller.ingressClassResource.default"
    value = true
  }
}

