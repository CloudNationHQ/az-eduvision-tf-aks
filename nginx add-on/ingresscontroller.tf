# resource "kubernetes_manifest" "ingress_controller" {
#   manifest = yamldecode(templatefile("${path.module}/manifests/ingress-controller-default.yaml", {}))
# }
# resource "kubernetes_manifest" "ingress_controller" {
#   manifest = yamldecode(templatefile("${path.module}/manifests/ingress-controller-internal.yaml", {}))
# }
# resource "kubernetes_manifest" "ingress" {
#   manifest = yamldecode(templatefile("${path.module}/manifests/ingress.yaml", {}))
# }

# resource "terraform_data" "remove_default_ingress_controller" {
#   provisioner "local-exec" {
#     command = "kubectl delete -f ${path.module}/manifests/ingress-controller-default.yaml"
#   }
# }
