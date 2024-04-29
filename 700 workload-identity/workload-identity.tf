resource "azurerm_user_assigned_identity" "workload" {
  location            = module.rg.groups.default.location
  resource_group_name = module.rg.groups.default.name
  name                = module.naming_workload.user_assigned_identity.name
}
resource "azurerm_federated_identity_credential" "workload" {
  name                = azurerm_user_assigned_identity.workload.name
  resource_group_name = module.rg.groups.default.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.default.oidc_issuer_url
  parent_id           = azurerm_user_assigned_identity.workload.id
  subject             = "system:serviceaccount:${local.namespace}:${local.service_account_name}"
}

resource "azurerm_role_assignment" "workload_to_key_vault" {
  scope                = module.kv.vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.workload.principal_id
}
