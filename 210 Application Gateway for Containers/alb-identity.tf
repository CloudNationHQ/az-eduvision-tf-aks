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
  parent_id = azurerm_user_assigned_identity.alb_identity.id
}

resource "azurerm_role_assignment" "alb_reader" {
  #scope                = module.rg.groups.demo.id
  #scope                = "/subscriptions/6ed2fd5a-6517-4451-8ce2-40f8fa83b677/resourceGroups/rg-test-node"
  scope                = module.aks.cluster.node_resource_group_id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.alb_identity.principal_id
}

/*
# Delegate AppGw for Containers Configuration Manager role to AKS Managed Cluster RG
az role assignment create --assignee-object-id $principalId --assignee-principal-type ServicePrincipal --scope $mcResourceGroupId --role "fbc52c3f-28ad-4303-a892-8a056630b8f1" 

# Delegate Network Contributor permission for join to association subnet
az role assignment create --assignee-object-id $principalId --assignee-principal-type ServicePrincipal --scope $ALB_SUBNET_ID --role "4d97b98b-1d4f-4787-a291-c67834d212e7" 
*/

resource "azurerm_role_assignment" "alb_manager" {
  #scope                = module.rg.groups.demo.id
  #scope                = "/subscriptions/6ed2fd5a-6517-4451-8ce2-40f8fa83b677/resourceGroups/rg-test-node"
  scope                = module.aks.cluster.node_resource_group_id
  role_definition_name = "AppGw for Containers Configuration Manager"
  principal_id         = azurerm_user_assigned_identity.alb_identity.principal_id
}

resource "azurerm_role_assignment" "network_contributor" {
  scope                = azurerm_subnet.alb.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.alb_identity.principal_id
}

# resource "azurerm_role_assignment" "alb_node_reader" {
#   scope                = "/subscriptions/6ed2fd5a-6517-4451-8ce2-40f8fa83b677/resourceGroups/rg-test-node"
#   role_definition_name = "Reader"
#   principal_id         = azurerm_user_assigned_identity.workload_identity.principal_id
# }
