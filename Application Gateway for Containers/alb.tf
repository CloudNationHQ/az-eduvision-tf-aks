/*
az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_NAME
helm install alb-controller oci://mcr.microsoft.com/application-lb/charts/alb-controller --namespace <helm-resource-namespace> --version 1.0.0 --set albController.namespace=<alb-controller-namespace> --set albController.podIdentity.clientID=$(az identity show -g $RESOURCE_GROUP -n azure-alb-identity --query clientId -o tsv)
*/

resource "helm_release" "alb" {
  #count      = 0
  chart      = "alb-controller"
  name       = "alb-controller"
  repository = "oci://mcr.microsoft.com/application-lb/charts"
  #namespace  = "kube-system"
  #values = ["${file("${path.module}/ingress_controller_values.yaml")}"]
  #version = "1.0.0"
  set {
    name  = "albController.podIdentity.clientID"
    value = azurerm_user_assigned_identity.workload_identity.client_id
  }
  #depends_on = [azurerm_role_assignment.aks_to_public_ip_reader, azurerm_role_assignment.aks_to_public_ip_network_contributor]
}

/*
az network vnet subnet create \
  --resource-group $VNET_RESOURCE_GROUP \
  --vnet-name $VNET_NAME \
  --name $ALB_SUBNET_NAME \
  --address-prefixes $SUBNET_ADDRESS_PREFIX \
  --delegations 'Microsoft.ServiceNetworking/trafficControllers'
  */

resource "azurerm_subnet" "alb" {
  name                = "subnet-alb"
  resource_group_name = "rg-test-node"
  address_prefixes    = ["10.225.0.0/16"]
  #https://portal.azure.com/#@carlintveld.onmicrosoft.com/resource/subscriptions/6ed2fd5a-6517-4451-8ce2-40f8fa83b677/resourceGroups/rg-test-node/providers/Microsoft.Network/virtualNetworks/aks-vnet-41067869/overview
  virtual_network_name = "aks-vnet-41067869"
  delegation {
    name = "delegation"
    service_delegation {
      name = "Microsoft.ServiceNetworking/trafficControllers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}

/*
# Delegate AppGw for Containers Configuration Manager role to AKS Managed Cluster RG
az role assignment create --assignee-object-id $principalId --assignee-principal-type ServicePrincipal --scope $mcResourceGroupId --role "fbc52c3f-28ad-4303-a892-8a056630b8f1" 

# Delegate Network Contributor permission for join to association subnet
az role assignment create --assignee-object-id $principalId --assignee-principal-type ServicePrincipal --scope $ALB_SUBNET_ID --role "4d97b98b-1d4f-4787-a291-c67834d212e7" 
*/

resource "azurerm_role_assignment" "alb_manager" {
  #scope                = module.rg.groups.demo.id
  scope                = "/subscriptions/6ed2fd5a-6517-4451-8ce2-40f8fa83b677/resourceGroups/rg-test-node"
  role_definition_name = "AppGw for Containers Configuration Manager"
  principal_id         = azurerm_user_assigned_identity.workload_identity.principal_id
}

resource "azurerm_role_assignment" "network_contributor" {
  scope                = azurerm_subnet.alb.id
  role_definition_name = "Network Contributor"
  principal_id         = azurerm_user_assigned_identity.workload_identity.principal_id
}

provider "kubernetes" {
  host                   = module.aks.cluster.kube_config.0.host
  client_certificate     = base64decode(module.aks.cluster.kube_admin_config.0.client_certificate)
  client_key             = base64decode(module.aks.cluster.kube_admin_config.0.client_key)
  cluster_ca_certificate = base64decode(module.aks.cluster.kube_admin_config.0.cluster_ca_certificate)
}

resource "kubernetes_namespace" "alb" {
  metadata {
    name = "azure-test-infra"
  }
}

resource "kubernetes_manifest" "alb" {
  manifest = {
    apiVersion = "alb.networking.azure.io/v1"
    kind       = "ApplicationLoadBalancer"
    metadata = {
      namespace = kubernetes_namespace.alb.metadata.0.name
      name      = "alb-test"
    }
    spec = {
      associations = [azurerm_subnet.alb.id]
    }
  }
}

# resource "azurerm_role_assignment" "alb_node_reader" {
#   scope                = "/subscriptions/6ed2fd5a-6517-4451-8ce2-40f8fa83b677/resourceGroups/rg-test-node"
#   role_definition_name = "Reader"
#   principal_id         = azurerm_user_assigned_identity.workload_identity.principal_id
# }
