resource "kubernetes_manifest" "blue" {
  manifest = yamldecode(templatefile("${path.module}/manifests/ingress.yaml", {
    namespace = kubernetes_namespace.default.metadata[0].name
    name      = "blue"
    path      = "/blue"
  }))
}

resource "kubernetes_manifest" "green" {
  manifest = yamldecode(templatefile("${path.module}/manifests/ingress.yaml", {
    namespace = kubernetes_namespace.default.metadata[0].name
    name      = "green"
    path      = "/green"
  }))
}
