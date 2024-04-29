module "aks" {
  source  = "cloudnationhq/aks/azure"
  version = "~> 0.7"

  keyvault = module.kv.vault.id

  cluster = {
    name          = module.naming.kubernetes_cluster.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
    depends_on    = [module.kv]
    profile       = "linux"
    dns_prefix    = "demo"
    default_node_pool = {
      vm_size = "Standard_D2as_v5"
      zones   = [3]
    }
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

module "kv" {
  source  = "cloudnationhq/kv/azure"
  version = "~> 0.8"

  vault = {
    name          = module.naming.key_vault.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
  }
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 0.7"

  groups = {
    demo = {
      name   = module.naming.resource_group.name_unique
      region = "westeurope"
    }
  }
}

module "naming" {
  source = "Azure/naming/azurerm"
  suffix = [local.workload_name]
}
