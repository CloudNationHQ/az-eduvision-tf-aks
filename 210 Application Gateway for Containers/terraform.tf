provider "azurerm" {
  features {}
  subscription_id            = local.subscription_id
  skip_provider_registration = true
}

provider "helm" {
  kubernetes {
    host                   = module.aks.cluster.kube_config.0.host
    client_certificate     = base64decode(module.aks.cluster.kube_admin_config.0.client_certificate)
    client_key             = base64decode(module.aks.cluster.kube_admin_config.0.client_key)
    cluster_ca_certificate = base64decode(module.aks.cluster.kube_admin_config.0.cluster_ca_certificate)
  }
}

provider "kubernetes" {
  host                   = module.aks.cluster.kube_config.0.host
  client_certificate     = base64decode(module.aks.cluster.kube_admin_config.0.client_certificate)
  client_key             = base64decode(module.aks.cluster.kube_admin_config.0.client_key)
  cluster_ca_certificate = base64decode(module.aks.cluster.kube_admin_config.0.cluster_ca_certificate)
}

provider "kubectl" {
  host                   = module.aks.cluster.kube_config.0.host
  client_certificate     = base64decode(module.aks.cluster.kube_admin_config.0.client_certificate)
  client_key             = base64decode(module.aks.cluster.kube_admin_config.0.client_key)
  cluster_ca_certificate = base64decode(module.aks.cluster.kube_admin_config.0.cluster_ca_certificate)
}

terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}
