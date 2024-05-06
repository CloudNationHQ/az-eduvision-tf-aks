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
