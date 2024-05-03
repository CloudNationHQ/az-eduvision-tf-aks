resource "azurerm_role_assignment" "aks_admin" {
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  scope                = azurerm_kubernetes_cluster.default.id
  principal_id         = data.azurerm_client_config.default.object_id
}

resource "random_string" "default" {
  length  = 5
  special = false
  upper   = false
  numeric = false
}

data "azurerm_client_config" "default" {
}

# resource "azurerm_user_assigned_identity" "default" {
#   location            = azurerm_resource_group.default.location
#   name                = "id-${local.workload_name}-${random_string.default.result}"
#   resource_group_name = azurerm_resource_group.default.name
# }

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
    location      = module.rg.groups.default.location
    resourcegroup = module.rg.groups.default.name
  }
}

resource "time_sleep" "default" {
  depends_on      = [module.kv]
  create_duration = "15s"
}

resource "terraform_data" "default" {
  depends_on = [time_sleep.default]
  input = {
    key_vault = module.kv.vault
  }
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 0.7"

  groups = {
    default = {
      name   = module.naming.resource_group.name_unique
      region = "westeurope"
    }
  }
}

module "naming" {
  source = "Azure/naming/azurerm"
  suffix = [local.usecase, local.workload_name]
}

locals {
  usecase = "app-routing"
}
