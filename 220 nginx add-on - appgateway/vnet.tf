resource "azurerm_virtual_network" "default" {
  name                = module.naming.virtual_network.name_unique
  resource_group_name = module.rg.groups.default.name
  location            = module.rg.groups.default.location
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "frontend" {
  name                 = module.naming.subnet.name_unique
  resource_group_name  = module.rg.groups.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.1.1.0/24"]
}

resource "azurerm_subnet" "aks" {
  name                 = module.naming_aks.subnet.name_unique
  resource_group_name  = module.rg.groups.default.name
  virtual_network_name = azurerm_virtual_network.default.name
  address_prefixes     = ["10.1.8.0/21"]
}

# resource "azurerm_route_table" "appgw_route" {
#   name                          = module.naming.route_table.name_unique
#   location                      = azurerm_resource_group.default.location
#   resource_group_name           = azurerm_resource_group.default.name
#   disable_bgp_route_propagation = false

#   # route {
#   #   name                   = "appgw-to-aci-one"
#   #   address_prefix         = var.aci_subnet_cidr.one.cidr
#   #   next_hop_type          = "VirtualAppliance"
#   #   next_hop_in_ip_address = var.firewall_ip
#   # }
#   # route {
#   #   name                   = "appgw-to-aci-two"
#   #   address_prefix         = var.aci_subnet_cidr.two.cidr
#   #   next_hop_type          = "VirtualAppliance"
#   #   next_hop_in_ip_address = var.firewall_ip
#   # }

#   route {
#     name           = "appgw-to-internet"
#     address_prefix = "0.0.0.0/0"
#     next_hop_type  = "Internet"
#     # next_hop_in_ip_address = data.azurerm_firewall.fw.virtual_hub[0].private_ip_address
#   }

#   tags = {
#     section = "connectivity"
#   }
# }

# resource "azurerm_subnet_route_table_association" "appgw_route_assoc" {
#   subnet_id      = azurerm_subnet.frontend.id
#   route_table_id = azurerm_route_table.appgw_route.id
# }



