resource "tls_private_key" "tls_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_key_vault_secret" "tls_public_key_secret" {
  name         = format("%s-%s-%s", "kvs", local.cluster_name, "pub")
  value        = tls_private_key.tls_key.public_key_openssh
  key_vault_id = module.kv.vault.id
}

resource "azurerm_key_vault_secret" "tls_private_key_secret" {
  name         = format("%s-%s-%s", "kvs", local.cluster_name, "prv")
  value        = tls_private_key.tls_key.private_key_pem
  key_vault_id = module.kv.vault.id
}

resource "azurerm_role_assignment" "aks_to_kubelet_id" {
  role_definition_name = "Managed Identity Operator"
  scope                = azurerm_user_assigned_identity.aks_kubelet.id
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

locals {
  cluster_name = module.naming.kubernetes_cluster.name_unique
}

resource "azurerm_kubernetes_cluster" "default" {
  name                = local.cluster_name
  location            = module.rg.groups.demo.location
  resource_group_name = module.rg.groups.demo.name
  depends_on          = [azurerm_role_assignment.aks_to_kubelet_id, azurerm_role_assignment.aks_to_vnet]
  linux_profile {

    admin_username = "nodeadmin"
    ssh_key {
      key_data = azurerm_key_vault_secret.tls_public_key_secret.value
    }
  }
  dns_prefix = local.workload_name
  default_node_pool {
    node_count = 1
    name       = "default"
    vm_size    = "Standard_D2as_v5"
    zones      = [3]
    upgrade_settings {
      max_surge = "10%"
    }
    vnet_subnet_id              = azurerm_subnet.aks.id
    temporary_name_for_rotation = "temporary"
  }
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.aks.id]
  }
  web_app_routing {
    dns_zone_id = ""
  }
  azure_active_directory_role_based_access_control {
    admin_group_object_ids = [data.azurerm_client_config.default.object_id]
    azure_rbac_enabled     = true
    managed                = true
  }
  local_account_disabled = true
  kubelet_identity {
    user_assigned_identity_id = azurerm_user_assigned_identity.aks_kubelet.id
    client_id                 = azurerm_user_assigned_identity.aks_kubelet.client_id
    object_id                 = azurerm_user_assigned_identity.aks_kubelet.principal_id
  }
}
