module "naming" {
  source = "Azure/naming/azurerm"
  suffix = [local.usecase, local.workload_name]
}
