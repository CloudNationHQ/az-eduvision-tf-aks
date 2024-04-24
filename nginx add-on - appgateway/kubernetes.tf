# provider "kubernetes" {
#   host                   = module.aks.cluster.kube_config.0.host
#   client_certificate     = base64decode(module.aks.cluster.kube_admin_config.0.client_certificate)
#   client_key             = base64decode(module.aks.cluster.kube_admin_config.0.client_key)
#   cluster_ca_certificate = base64decode(module.aks.cluster.kube_admin_config.0.cluster_ca_certificate)
# }

# data "azuread_service_principal" "aks" {
#   display_name = "Azure Kubernetes Service AAD Server"
# }

provider "kubernetes" {
  #host = module.aks.cluster.kube_config.0.host
  host = azurerm_kubernetes_cluster.default.kube_config.0.host
  cluster_ca_certificate = base64decode(
    #module.aks.cluster.kube_config[0].cluster_ca_certificate,
    azurerm_kubernetes_cluster.default.kube_config[0].cluster_ca_certificate,
  )
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "kubelogin"
    args = [
      "get-token",
      "--login",
      "azurecli",
      "--server-id",
      "6dae42f8-4368-4678-94ff-3960e28e3630" # data.azuread_service_principal.aks.client_id
    ]
  }
}

resource "kubernetes_namespace" "default" {
  metadata {
    name = "example"
  }
}

moved {
  from = module.aks.azurerm_kubernetes_cluster.aks
  to   = azurerm_kubernetes_cluster.default
}

moved {
  from = module.aks.tls_private_key.tls_key["default"]
  to   = tls_private_key.tls_key
}

moved {
  from = module.aks.azurerm_key_vault_secret.tls_private_key_secret["default"]
  to   = azurerm_key_vault_secret.tls_private_key_secret
}

moved {
  from = module.aks.azurerm_key_vault_secret.tls_public_key_secret["default"]
  to   = azurerm_key_vault_secret.tls_public_key_secret
}
