# the following is required to switch the default ingress controller to private:
# resource "kubectl_manifest" "default_ingress_controller" {
#   yaml_body = file("${path.module}/manifests/ingress-controller-default.yaml")
# }


