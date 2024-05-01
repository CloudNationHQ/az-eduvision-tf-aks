/*
az network vnet subnet create \
  --resource-group $VNET_RESOURCE_GROUP \
  --vnet-name $VNET_NAME \
  --name $ALB_SUBNET_NAME \
  --address-prefixes $SUBNET_ADDRESS_PREFIX \
  --delegations 'Microsoft.ServiceNetworking/trafficControllers'
  */

resource "azurerm_subnet" "alb" {
  # count               = length(data.azurerm_resources.vnet.resources) > 0 ? 1 : 0
  name                = "subnet-alb"
  resource_group_name = module.aks.cluster.node_resource_group
  address_prefixes    = ["10.225.0.0/16"]
  #https://portal.azure.com/#@carlintveld.onmicrosoft.com/resource/subscriptions/6ed2fd5a-6517-4451-8ce2-40f8fa83b677/resourceGroups/rg-test-node/providers/Microsoft.Network/virtualNetworks/aks-vnet-41067869/overview
  virtual_network_name = data.azurerm_resources.vnet.resources[0].name
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

data "azurerm_resources" "vnet" {
  type                = "Microsoft.Network/virtualNetworks"
  resource_group_name = module.aks.cluster.node_resource_group
}
