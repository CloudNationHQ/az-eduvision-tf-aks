/*
az aks get-credentials --resource-group $RESOURCE_GROUP --name $AKS_NAME
helm install alb-controller oci://mcr.microsoft.com/application-lb/charts/alb-controller --namespace <helm-resource-namespace> --version 1.0.0 --set albController.namespace=<alb-controller-namespace> --set albController.podIdentity.clientID=$(az identity show -g $RESOURCE_GROUP -n azure-alb-identity --query clientId -o tsv)
*/

resource "helm_release" "alb" {
  #count      = 0
  chart      = "alb-controller"
  name       = "alb-controller"
  repository = "oci://mcr.microsoft.com/application-lb/charts"
  #namespace  = "kube-system"
  #values = ["${file("${path.module}/ingress_controller_values.yaml")}"]
  #version = "1.0.0"
  set {
    name  = "albController.podIdentity.clientID"
    value = azurerm_user_assigned_identity.alb_identity.client_id
  }
  #depends_on = [azurerm_role_assignment.aks_to_public_ip_reader, azurerm_role_assignment.aks_to_public_ip_network_contributor]
}

moved {
  from = module.kubernetes[0].helm_release.alb
  to   = helm_release.alb
}
