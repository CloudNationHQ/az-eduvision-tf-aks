provider "azurerm" {
  features {}
  subscription_id            = local.subscription_id
  skip_provider_registration = true
}

locals {
  subscription_id = local.subscription_id
}

provider "helm" {
  kubernetes {
    host                   = module.aks.cluster.kube_config.0.host
    client_certificate     = base64decode(module.aks.cluster.kube_admin_config.0.client_certificate)
    client_key             = base64decode(module.aks.cluster.kube_admin_config.0.client_key)
    cluster_ca_certificate = base64decode(module.aks.cluster.kube_admin_config.0.cluster_ca_certificate)
  }
}
