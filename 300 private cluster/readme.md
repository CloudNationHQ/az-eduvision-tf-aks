# Exercise 300 private cluster
## Goal of this exercise
This exercise will provision a Azure Kubernetes Service cluster with the API server a private IP assigned from the subnet.

## Steps
1. Copy `environment.tf.example` to `environment.tf` and fill in your personal settings
2. Run `terraform init`
3. Run `terraform apply`

## Things you can try
* Review the API server address that it is a private ip
* Run `az aks command invoke` to manage the cluster (note it can take ~10 minutes before your role assignment takes effect)
* Do note that there is still a public ip. This is because the API server lives in the host control plane (HCP) and there must be a route from your subnet to the HCP.
* Vnet integration is currently in public preview. You can try this out. You will notice that a public ip is not required anymore. 
* If you desire to use generally available features and leave out the public ip you can go for user defined routes.

## References
* https://learn.microsoft.com/en-us/azure/aks/private-clusters
* https://learn.microsoft.com/en-us/azure/aks/access-private-cluster
* https://learn.microsoft.com/en-us/azure/aks/api-server-vnet-integration