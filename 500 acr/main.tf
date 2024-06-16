resource "azurerm_role_assignment" "aks_admin" {
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  #scope                = module.aks.cluster.id
  scope        = azurerm_kubernetes_cluster.default.id
  principal_id = data.azurerm_client_config.default.object_id
}

data "azurerm_client_config" "default" {
}

resource "azurerm_user_assigned_identity" "aks" {
  location            = module.rg.groups.default.location
  name                = module.naming_aks.user_assigned_identity.name_unique
  resource_group_name = module.rg.groups.default.name
}

resource "azurerm_user_assigned_identity" "aks_kubelet" {
  location            = module.rg.groups.default.location
  name                = module.naming_kubelet.user_assigned_identity.name_unique
  resource_group_name = module.rg.groups.default.name
}

resource "azurerm_role_assignment" "aks_to_acr" {
  principal_id         = azurerm_user_assigned_identity.aks_kubelet.principal_id
  role_definition_name = "AcrPull"
  scope                = azurerm_container_registry.default.id
}

resource "azurerm_role_assignment" "aks_to_kubelet_identity" {
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
  role_definition_name = "Managed Identity Operator"
  scope                = azurerm_user_assigned_identity.aks_kubelet.id
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 0.7"

  groups = {
    default = {
      name   = module.naming.resource_group.name_unique
      region = local.location
    }
  }
}
