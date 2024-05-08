# Example taken from: 
# https://learn.microsoft.com/en-us/azure/application-gateway/for-containers/how-to-traffic-splitting-gateway-api?tabs=alb-managed

# Create a ALB frontend:
resource "kubectl_manifest" "gateway" {
  yaml_body = yamlencode({
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "Gateway"
    metadata = {
      name      = local.gateway_name
      namespace = kubernetes_namespace.default.metadata.0.name
      annotations = {
        "alb.networking.azure.io/alb-namespace" = kubernetes_namespace.default.metadata.0.name
        "alb.networking.azure.io/alb-name"      = local.alb_name
      }
    }
    spec = {
      gatewayClassName = "azure-alb-external"
      listeners = [{
        name     = "http"
        port     = 80
        protocol = "HTTP"
        allowedRoutes = {
          namespaces = {
            from = "Same"
          }
        }
      }]
    }
  })
}
