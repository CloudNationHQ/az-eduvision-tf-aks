# Exercise 550 storage
## Goal of this exercise
This exercise will provision a public Azure Kubernetes Service (AKS) cluster with a pod that gets an Azure fileshare

## Steps
1. Copy `environment.tf.example` to `environment.tf` and fill in your personal settings
2. Run `terraform init`
3. Run `terraform apply`

## Things you can try
* Review the configuration of the fileshare
* Connect with the pod and put a file in it. Review that it becomes available in Azure portal.
* This exercise uses managed storage. Review the resources in the AKS linked resource group
* You can try to mount fileshare from a storage account you have provisioned yourself

## References
* https://learn.microsoft.com/en-us/azure/aks/concepts-storage