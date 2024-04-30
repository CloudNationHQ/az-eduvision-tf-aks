module "kv" {
  source  = "cloudnationhq/kv/azure"
  version = "~> 0.8"

  vault = {
    name          = module.naming.key_vault.name_unique
    location      = module.rg.groups.default.location
    resourcegroup = module.rg.groups.default.name
  }
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 0.7"

  groups = {
    default = {
      name   = module.naming.resource_group.name
      region = "westeurope"
    }
  }
}
