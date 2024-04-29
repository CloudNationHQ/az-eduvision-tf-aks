data "azurerm_client_config" "default" {
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 0.7"

  groups = {
    default = {
      name   = module.naming.resource_group.name_unique
      region = "westeurope"
    }
  }

}
