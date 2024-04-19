locals {
  //SERVICE_ACCOUNT_NAMESPACE = var.namespace_name
}
resource "azurerm_user_assigned_identity" "alb_identity" {
  resource_group_name = module.rg.groups.demo.name
  name                = "id-alb-identity"
  location            = local.location
}

# documentation: https://learn.microsoft.com/en-us/azure/aks/learn/tutorial-kubernetes-workload-identity
locals {
  SERVICE_ACCOUNT_NAME = "alb-identity"
}

# az identity federated-credential create --name ${FEDERATED_IDENTITY_CREDENTIAL_NAME} --identity-name ${USER_ASSIGNED_IDENTITY_NAME} --resource-group ${RESOURCE_GROUP} --issuer ${AKS_OIDC_ISSUER} --subject system:serviceaccount:${SERVICE_ACCOUNT_NAMESPACE}:${SERVICE_ACCOUNT_NAME}
resource "azurerm_federated_identity_credential" "alb_identity" {
  name   = module.aks.cluster.name
  issuer = module.aks.cluster.oidc_issuer_url
  audience = [
    "api://AzureADTokenExchange"
  ]
  #resource_group_name = azurerm_resource_group.workload_identity.name
  resource_group_name = module.rg.groups.demo.name
  #subject             = "system:serviceaccount:${local.SERVICE_ACCOUNT_NAMESPACE}:${local.SERVICE_ACCOUNT_NAME}"
  subject   = "system:serviceaccount:azure-alb-system:alb-controller-sa"
  parent_id = azurerm_user_assigned_identity.workload_identity.id
}

resource "azurerm_role_assignment" "alb-reader" {
  #scope                = module.rg.groups.demo.id
  scope                = "/subscriptions/6ed2fd5a-6517-4451-8ce2-40f8fa83b677/resourceGroups/rg-test-node"
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.workload_identity.principal_id
}
