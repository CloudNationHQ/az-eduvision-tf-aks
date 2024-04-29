resource "kubernetes_service_account" "workload" {
  metadata {
    name      = var.service_account_name
    namespace = var.namespace
    annotations = {
      "azure.workload.identity/client-id" = var.workload_managed_identity_id
    }
  }
}
