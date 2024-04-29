# taken from https://github.com/markti/terraform-hashitalks-2024/blob/main/src/terraform/k8s/keyvault.tf
resource "kubectl_manifest" "shared_secrets" {
  yaml_body = yamlencode({
    apiVersion = "secrets-store.csi.x-k8s.io/v1"
    kind       = "SecretProviderClass"
    metadata = {
      name      = local.secret_provider_class_name
      namespace = var.namespace
    }
    spec = {
      provider = "azure"
      secretObjects = [
        {
          data = [
            {
              key        = "example"
              objectName = "example"
            }
          ]
          secretName = "example"
          type       = "Opaque"
        }
      ]
      parameters = {
        usePodIdentity = "false"
        clientID       = var.workload_managed_identity_id
        keyvaultName   = var.key_vault_name
        cloudName      = ""
        objects        = <<OBJECTS
              array:
                - |
                  objectName: example
                  objectType: secret
                  objectVersion: ""
        OBJECTS
        tenantId       = data.azurerm_client_config.default.tenant_id
      }
    }
  })
}
