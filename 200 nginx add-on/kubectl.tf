# provider "kubernetes" {
#   host                   = module.aks.cluster.kube_config.0.host
#   client_certificate     = base64decode(module.aks.cluster.kube_admin_config.0.client_certificate)
#   client_key             = base64decode(module.aks.cluster.kube_admin_config.0.client_key)
#   cluster_ca_certificate = base64decode(module.aks.cluster.kube_admin_config.0.cluster_ca_certificate)
# }

# data "azuread_service_principal" "aks" {
#   display_name = "Azure Kubernetes Service AAD Server"
# }

provider "kubectl" {
  host = module.aks.cluster.kube_config.0.host
  cluster_ca_certificate = base64decode(
    module.aks.cluster.kube_config[0].cluster_ca_certificate,
  )
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "kubelogin"
    args = [
      "get-token",
      "--login",
      "azurecli",
      "--server-id",
      "6dae42f8-4368-4678-94ff-3960e28e3630" # data.azuread_service_principal.aks.client_id
    ]
  }
}

resource "kubectl_manifest" "default_ingress_controller" {
  yaml_body = file("${path.module}/manifests/ingress-controller-default.yaml")
}

terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}
