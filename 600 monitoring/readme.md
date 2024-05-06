# Exercise 600 monitoring
## Goal of this exercise
This exercise will provision a public Azure Kubernetes Service cluster and managed monitoring infrastructure.

## Steps
1. Copy `environment.tf.example` to `environment.tf` and fill in your personal settings
2. Run `terraform init`
3. Run `terraform apply`
4. You will need to connect AKS with the monitoring workspace through Azure Portal.

## Things you can try
* Connect AKS with the monitoring workspace
* Review the build-in Grafana dashboard

## References
* https://learn.microsoft.com/en-us/azure/aks/monitor-aks