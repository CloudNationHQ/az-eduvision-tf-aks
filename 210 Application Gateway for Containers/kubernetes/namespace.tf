resource "kubernetes_namespace" "default" {
  metadata {
    name = "azure-test-infra"
  }
}

moved {
  from = kubernetes_namespace.alb
  to   = kubernetes_namespace.default
}
