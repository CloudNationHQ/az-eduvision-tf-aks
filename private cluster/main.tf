module "aks" {
  source                            = "Azure/aks/azurerm"
  version                           = ">= 8.0.0, < 9.0.0"
  resource_group_name               = azurerm_resource_group.default.name
  prefix                            = "${local.workload_name}-${random_string.default.result}"
  role_based_access_control_enabled = true
  private_cluster_enabled           = true
  rbac_aad                          = true
  rbac_aad_managed                  = true
  log_analytics_workspace_enabled   = true
  rbac_aad_admin_group_object_ids   = []
  rbac_aad_azure_rbac_enabled       = true
  rbac_aad_tenant_id                = data.azurerm_client_config.default.tenant_id
  private_dns_zone_id               = azurerm_private_dns_zone.aks.id
  identity_type                     = "UserAssigned"
  identity_ids                      = [azurerm_user_assigned_identity.default.id]
}


resource "azurerm_role_assignment" "uami-to-private-dns-zone" {
  scope                = azurerm_private_dns_zone.aks.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.default.principal_id
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

resource "azurerm_user_assigned_identity" "default" {
  location            = azurerm_resource_group.default.location
  name                = "id-${local.workload_name}-${random_string.default.result}"
  resource_group_name = azurerm_resource_group.default.name
}

resource "azurerm_private_dns_zone" "aks" {
  name                = "privatelink.westeurope.azmk8s.io"
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
