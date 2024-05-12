resource "tls_private_key" "tls_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_key_vault_secret" "tls_public_key_secret" {
  name         = join("-", ["kvs", local.cluster_name, "pub"])
  value        = tls_private_key.tls_key.public_key_openssh
  key_vault_id = terraform_data.default.output.key_vault_id
}

resource "azurerm_key_vault_secret" "tls_private_key_secret" {
  name         = join("-", ["kvs", local.cluster_name, "prv"])
  value        = tls_private_key.tls_key.private_key_pem
  key_vault_id = terraform_data.default.output.key_vault_id
}

locals {
  cluster_name = module.naming.kubernetes_cluster.name_unique
}

resource "azurerm_kubernetes_cluster" "default" {
  name                = local.cluster_name
  location            = module.rg.groups.default.location
  resource_group_name = module.rg.groups.default.name
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
    vm_size    = "standard_d4as_v5"
    zones      = [3]
    upgrade_settings {
      max_surge = "10%"
    }
  }
  identity {
    type = "SystemAssigned"
  }
  web_app_routing {
    dns_zone_id = azurerm_private_dns_zone.default.id # up to 5, comma separated
  }
  azure_active_directory_role_based_access_control {
    admin_group_object_ids = [data.azurerm_client_config.default.object_id]
    azure_rbac_enabled     = true
    managed                = true
  }
  local_account_disabled = true
}

resource "azurerm_private_dns_zone" "default" {
  name                = "${module.naming.private_dns_zone.name_unique}.local"
  resource_group_name = module.rg.groups.default.name
}
