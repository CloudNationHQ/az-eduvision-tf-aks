output "aks" {
  value = module.aks.cluster.id
}

output "az_get_credentials" {
  value = "az aks get-credentials --resource-group ${module.rg.groups.default.name} --name ${local.cluster_name} --subscription ${local.subscription_id}"
}

output "kubelogin_convert" {
  value = "kubelogin convert-kubeconfig --login azurecli"
}
