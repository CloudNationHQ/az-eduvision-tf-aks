# Example 200 nginx add-on - public
## Goal of this exercise
This exercise will provision a public Azure Kubernetes Service cluster and enables the application routing add-on.

This Application routing add-on creates an nginx based ingress controller and provides a public ip to the ingress endpoint.

## Steps
1. Copy `environment.tf.example` to `environment.tf` and fill in your personal settings
2. Run `terraform init`
3. Run `terraform apply`

## Things you can try
* Review the public ip that is assigned to the ingress controller's endpoint. 
* Run http://_public-ip_/blue and http://_public_ip/green in the browser to verify that the ingress controller is routing the traffic to the specific services.
* Do note that the application router is creating a public endpoint by default. Within the file `kubernetes/kubectl.tf` uncomment the `kubectl_manifest` resource in order to make the endpoint private.

## References
* https://learn.microsoft.com/en-us/azure/aks/app-routing