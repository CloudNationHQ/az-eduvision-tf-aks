module "naming" {
  source = "Azure/naming/azurerm"
  suffix = [local.usecase, local.workload_name]
}

module "naming_aks" {
  source = "Azure/naming/azurerm"
  suffix = ["${local.usecase}-aks", local.workload_name]
}

module "naming_kubelet" {
  source = "Azure/naming/azurerm"
  suffix = ["${local.usecase}-aks-kubelet", local.workload_name]
}

locals {
  usecase              = "acr"
  resource_name_suffix = join("-", [local.usecase, local.workload_name, substr(module.naming.unique-seed, 0, 4)])
}
