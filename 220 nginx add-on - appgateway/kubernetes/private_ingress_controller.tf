# the following is required to switch the default ingress controller to private:
resource "kubectl_manifest" "default_ingress_controller" {
  count = var.private_ingress_endpoint_enabled ? 1 : 0
  yaml_body = templatefile("${path.module}/manifests/ingress-controller-default.yaml", {
    private_ingress_endpoint_ip = var.private_ingress_endpoint_ip
  })
}
