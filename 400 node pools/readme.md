# Exercise 400 node pools
## Goal of this exercise
This exercise will provision a public Azure Kubernetes Service cluster. Then you can fiddle with node pools.

## Steps
1. Copy `environment.tf.example` to `environment.tf` and fill in your personal settings
2. Run `terraform init`
3. Run `terraform apply`

## Things you can try
* Uncomment the relevant section in `aks.tf` to add a user node pool
* Switch the vm-size in the default system node pool and observe the behavior in Azure portal

## References
* https://learn.microsoft.com/en-us/azure/aks/create-node-pools