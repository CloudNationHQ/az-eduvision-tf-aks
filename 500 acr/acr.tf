resource "azurerm_container_registry" "default" {
  name                = module.naming.container_registry.name_unique
  resource_group_name = module.rg.groups.default.name
  location            = module.rg.groups.default.location
  sku                 = "Standard"
}
