module "kubernetes" {
  source                           = "./kubernetes"
  private_ingress_endpoint_enabled = local.private_ingress_endpoint_enabled
  private_ingress_endpoint_ip      = "10.1.8.8"
}

resource "time_sleep" "nginx_addon" {
  create_duration = "30s"
  depends_on      = [azurerm_role_assignment.aks_admin]
}

resource "terraform_data" "kubernetes" {
  depends_on = [time_sleep.nginx_addon]
  input      = azurerm_kubernetes_cluster.default
}


# data "azuread_service_principal" "aks" {
#   display_name = "Azure Kubernetes Service AAD Server"
# }


# provider "kubernetes" {
#   host                   = module.aks.cluster.kube_config.0.host
#   client_certificate     = base64decode(module.aks.cluster.kube_admin_config.0.client_certificate)
#   client_key             = base64decode(module.aks.cluster.kube_admin_config.0.client_key)
#   cluster_ca_certificate = base64decode(module.aks.cluster.kube_admin_config.0.cluster_ca_certificate)
# }

provider "kubectl" {
  load_config_file = false
  host             = terraform_data.kubernetes.output.kube_config.0.host
  cluster_ca_certificate = base64decode(
    terraform_data.kubernetes.output.kube_config[0].cluster_ca_certificate,
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

terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

output "name" {
  value = terraform_data.kubernetes.output.kube_config.0.host
}

provider "kubernetes" {
  #host = module.aks.cluster.kube_config.0.host
  host = terraform_data.kubernetes.output.kube_config.0.host
  cluster_ca_certificate = base64decode(
    #module.aks.cluster.kube_config[0].cluster_ca_certificate,
    terraform_data.kubernetes.output.kube_config[0].cluster_ca_certificate,
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
