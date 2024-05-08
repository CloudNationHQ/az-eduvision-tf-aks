resource "kubectl_manifest" "alb" {
  yaml_body = yamlencode({
    apiVersion = "alb.networking.azure.io/v1"
    kind       = "ApplicationLoadBalancer"
    metadata = {
      namespace = kubernetes_namespace.default.metadata.0.name
      name      = local.alb_name
    }
    spec = {
      associations = [var.alb_subnet_id]
    }
  })
}
