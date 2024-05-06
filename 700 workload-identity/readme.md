# Exercise 700 workload identity
## Goal of this exercise
This exercise will provision a public Azure Kubernetes Service cluster and workload identity example

## Steps
1. Copy `environment.tf.example` to `environment.tf` and fill in your personal settings
2. Run `terraform init`
3. Run `terraform apply`

## Things you can try
* Review all the components involved:
    * service account
    * user assigned managed identity
* Review the application of the secret store csi:
    * the secret provider class
    * the volume mount on the pods: `/mnt/secrets-store`

## References
* https://learn.microsoft.com/en-us/azure/aks/workload-identity-overview
* https://learn.microsoft.com/en-us/azure/aks/csi-secrets-store-driver