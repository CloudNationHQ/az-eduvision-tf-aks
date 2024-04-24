resource "kubernetes_service" "name" {
  for_each = toset(["blue", "green"])
  metadata {
    name      = each.value
    namespace = kubernetes_namespace.default.metadata.0.name
  }
  spec {
    selector = {
      app = each.value
    }
    port {
      port        = 80
      target_port = 80
    }
  }
}



resource "kubernetes_deployment" "default" {
  for_each = toset(["blue", "green"])
  metadata {
    name      = each.value
    namespace = kubernetes_namespace.default.metadata.0.name
    labels = {
      app = each.value
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = each.value
      }
    }
    template {
      metadata {
        labels = {
          app = each.value
        }
      }
      spec {
        container {
          image = "carlintveld/backendexample:${each.value}"
          name  = each.value
          port {
            container_port = 80
          }
        }
      }
    }
  }
}
