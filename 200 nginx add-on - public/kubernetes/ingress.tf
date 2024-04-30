resource "kubectl_manifest" "blue" {
  yaml_body = templatefile("${path.module}/manifests/ingress.yaml", {
    namespace = kubernetes_namespace.default.metadata[0].name
    name      = "blue"
    path      = "/blue"
  })
}

resource "kubectl_manifest" "green" {
  yaml_body = templatefile("${path.module}/manifests/ingress.yaml", {
    namespace = kubernetes_namespace.default.metadata[0].name
    name      = "green"
    path      = "/green"
  })
}
