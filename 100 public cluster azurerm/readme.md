# Exercise 100 public cluster azurerm
## Goal of this exercise
This exercise will provision a public Azure Kubernetes Service cluster using the azurerm provider resource.

## Steps
1. Copy `environment.tf.example` to `environment.tf` and fill in your personal settings
2. Run `terraform init`
3. Run `terraform apply`

## Things you can try
* Connect with your cluster through k9s or lens
* Review the API server address that it is a public ip
* Verify the input properties provided to the resource

## References
* https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster