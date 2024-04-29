# credits: https://faultbucket.ca/2023/06/azure-managed-prometheus-and-grafana-with-terraform-part-2/

resource "azurerm_monitor_workspace" "default" {
  name                = "mw-${local.resource_name_suffix}"
  resource_group_name = module.rg.groups.default.name
  location            = module.rg.groups.default.location
}

resource "azurerm_dashboard_grafana" "default" {
  name                              = "amg-${local.resource_name_suffix}"
  resource_group_name               = module.rg.groups.default.name
  location                          = module.rg.groups.default.location
  api_key_enabled                   = true
  deterministic_outbound_ip_enabled = false
  public_network_access_enabled     = true
  identity {
    type = "SystemAssigned"
  }
  azure_monitor_workspace_integrations {
    resource_id = azurerm_monitor_workspace.default.id
  }
}

resource "azurerm_role_assignment" "grafana" {
  scope                = module.rg.groups.default.id
  role_definition_name = "Monitoring Reader"
  principal_id         = azurerm_dashboard_grafana.default.identity[0].principal_id
}

# Add role assignment to Grafana so an admin user can log in
resource "azurerm_role_assignment" "grafana-admin" {
  scope                = azurerm_dashboard_grafana.default.id
  role_definition_name = "Grafana Admin"
  principal_id         = data.azurerm_client_config.default.object_id
}

# Output the grafana url for usability
output "grafana_url" {
  value = azurerm_dashboard_grafana.default.endpoint
}
