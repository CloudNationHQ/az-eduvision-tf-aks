terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

# uncomment this resource block to make the nginx ingress controller private
# resource "kubectl_manifest" "default_ingress_controller" {
#   yaml_body = file("${path.module}/manifests/ingress-controller-default.yaml")
# }
