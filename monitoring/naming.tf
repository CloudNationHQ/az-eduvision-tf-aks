module "naming" {
  source = "Azure/naming/azurerm"
  suffix = [local.usecase, local.workload_name]
}

locals {
  usecase              = "monitoring"
  resource_name_suffix = join("-", [local.usecase, local.workload_name, substr(module.naming.unique-seed, 0, 4)])
}
