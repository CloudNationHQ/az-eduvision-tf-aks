locals {
  cluster_name = module.naming.kubernetes_cluster.name_unique
}
resource "azurerm_kubernetes_cluster" "default" {
  name = local.cluster_name
  default_node_pool {
    name       = "default"
    node_count = 1
    # Change the vm size and observe the behavior of the azurerm provider updating the system nodepool
    #vm_size    = "Standard_D2as_v5"
    vm_size = "Standard_D2s_v5"
    upgrade_settings {
      max_surge = "10%"
    }
    temporary_name_for_rotation = "temporary"
  }
  location            = "westeurope"
  resource_group_name = module.rg.groups.default.name
  identity {
    type = "SystemAssigned"
  }
  dns_prefix = local.workload_name

  azure_active_directory_role_based_access_control {
    admin_group_object_ids = [data.azurerm_client_config.default.object_id]
    azure_rbac_enabled     = true
    tenant_id              = data.azurerm_client_config.default.tenant_id
    managed                = true
  }
}

resource "azurerm_role_assignment" "aks_admin" {
  scope                = azurerm_kubernetes_cluster.default.id
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id         = data.azurerm_client_config.default.object_id
}

# You can uncomment the following block to create a user node pool:
resource "azurerm_kubernetes_cluster_node_pool" "default" {
  kubernetes_cluster_id = azurerm_kubernetes_cluster.default.id
  name                  = "userpool"
  node_count            = 1
  vm_size               = "Standard_D2as_v5"
}

resource "terraform_data" "kubernetes" {
  depends_on = [azurerm_role_assignment.aks_admin]
  input      = azurerm_kubernetes_cluster.default.kube_config
}
