module "aks" {
  source  = "cloudnationhq/aks/azure"
  version = "~> 0.8"

  keyvault = module.kv.vault.id

  cluster = {
    name          = module.naming.kubernetes_cluster.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    depends_on    = [module.kv]
    profile       = "linux"
    dns_prefix    = local.workload_name
    default_node_pool = {
      vm_size    = "Standard_D2as_v5"
      zones      = [3]
      node_count = 1
      upgrade_settings = {
        max_surge = "10%"
      }
    }
    network_profile = {
      network_plugin      = "azure"
      network_plugin_mode = "overlay"
    }
    rbac = {
      local_account_disabled = false
    }
    workload_identity_enabled = true
    oidc_issuer_enabled       = true
  }
}

/*
https://learn.microsoft.com/en-us/azure/application-gateway/for-containers/quickstart-deploy-application-gateway-for-containers-alb-controller?tabs=install-helm-windows
az aks create \
    --resource-group $RESOURCE_GROUP \
    --name $AKS_NAME \
    --location $LOCATION \
    --node-vm-size $VM_SIZE \
    --network-plugin azure \
    --enable-oidc-issuer \
    --enable-workload-identity \
    --generate-ssh-key
  */

