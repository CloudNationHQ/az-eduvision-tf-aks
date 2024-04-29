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
        service_account_name = var.service_account_name
        container {
          image = "carlintveld/backendexample:${each.value}"
          name  = each.value
          port {
            container_port = 80
          }
          volume_mount {
            name       = local.volume_name
            mount_path = "/mnt/secrets-store"
            read_only  = true
          }
        }
        volume {
          name = local.volume_name

          csi {
            driver    = "secrets-store.csi.k8s.io"
            read_only = true

            volume_attributes = {
              secretProviderClass = local.secret_provider_class_name
            }
          }
        }
      }
    }
  }
}

locals {
  volume_name = "secrets-store01-inline"
}
