resource "azurerm_kubernetes_cluster" "default" {
  name = module.naming.kubernetes_cluster.name_unique
  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "standard_d2s_v5"
    upgrade_settings {
      max_surge = "10%"
    }
  }
  location            = "northeurope" # module.rg.groups.default.location
  resource_group_name = module.rg.groups.default.name
  identity {
    type = "SystemAssigned"
  }
  dns_prefix = local.workload_name

  azure_active_directory_role_based_access_control {
    #admin_group_object_ids = [data.azurerm_client_config.default.object_id]
    azure_rbac_enabled = true
    tenant_id          = data.azurerm_client_config.default.tenant_id
    managed            = true
  }


  monitor_metrics {
    annotations_allowed = null
    labels_allowed      = null
  }

  oms_agent {
    log_analytics_workspace_id      = azurerm_log_analytics_workspace.default.id
    msi_auth_for_monitoring_enabled = true
  }
}

resource "azurerm_log_analytics_workspace" "default" {
  name                = module.naming.log_analytics_workspace.name_unique
  location            = module.rg.groups.default.location
  resource_group_name = module.rg.groups.default.name
}

resource "azurerm_role_assignment" "aks_admin" {
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  scope                = azurerm_kubernetes_cluster.default.id
  principal_id         = data.azurerm_client_config.default.object_id
}
