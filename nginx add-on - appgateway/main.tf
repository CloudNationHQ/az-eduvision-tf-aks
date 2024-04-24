
resource "azurerm_role_assignment" "aks_admin" {
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  #scope                = module.aks.cluster.id
  scope        = azurerm_kubernetes_cluster.default.id
  principal_id = data.azurerm_client_config.default.object_id
}

resource "azurerm_role_assignment" "aks_to_vnet" {
  role_definition_name = "Network Contributor"
  scope                = azurerm_subnet.aks.id
  #principal_id         = module.aks.cluster.principal_id
  principal_id = azurerm_user_assigned_identity.aks.principal_id
}

resource "random_string" "default" {
  length  = 5
  special = false
  upper   = false
  numeric = false
}

data "azurerm_client_config" "default" {
}

resource "azurerm_resource_group" "default" {
  name     = "rg-${local.workload_name}-${random_string.default.result}"
  location = "westeurope"
}

resource "azurerm_user_assigned_identity" "aks" {
  location            = azurerm_resource_group.default.location
  name                = "id-aks-${local.workload_name}-${random_string.default.result}"
  resource_group_name = azurerm_resource_group.default.name
}

resource "azurerm_user_assigned_identity" "aks_kubelet" {
  location            = azurerm_resource_group.default.location
  name                = "id-aks-kubelet-${local.workload_name}-${random_string.default.result}"
  resource_group_name = azurerm_resource_group.default.name
}

# resource "azurerm_log_analytics_workspace" "default" {
#   name                = "law-${local.workload_name}-${random_string.default.result}"
#   resource_group_name = azurerm_resource_group.default.name
#   location            = azurerm_resource_group.default.location
#   sku                 = "PerGB2018"
#   retention_in_days   = 30
#   # identity {
#   #   type = "SystemAssigned"
#   # }
# }
module "kv" {
  source  = "cloudnationhq/kv/azure"
  version = "~> 0.8"

  vault = {
    name          = module.naming.key_vault.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
  }
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 0.7"

  groups = {
    demo = {
      name   = module.naming.resource_group.name_unique
      region = "westeurope"
    }
  }
}

module "naming" {
  source = "Azure/naming/azurerm"
  suffix = [local.workload_name]
}

