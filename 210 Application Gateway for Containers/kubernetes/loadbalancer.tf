resource "kubernetes_namespace" "alb" {
  metadata {
    name = "azure-test-infra"
  }
}

resource "kubectl_manifest" "alb" {
  yaml_body = yamlencode({
    apiVersion = "alb.networking.azure.io/v1"
    kind       = "ApplicationLoadBalancer"
    metadata = {
      namespace = kubernetes_namespace.alb.metadata.0.name
      name      = "alb-test"
    }
    spec = {
      associations = [var.alb_subnet_id]
    }
  })
}
