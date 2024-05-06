# Exercise 210 Application Gateway for Containers
## Goal of this exercise
This exercise will provision a public Azure Kubernetes Service cluster and adds an application load balancer through the "kubernetes managed" model. 

## Steps
1. Copy `environment.tf.example` to `environment.tf` and fill in your personal settings
2. Run `terraform init`
3. Run `terraform apply`

## Things you can try
* Verify that the application load balancer has been created
* Add a listener, add ingress configuration, get the blue/green endpoints running
* Experiment with the "bring your own" model.

## References
* https://learn.microsoft.com/en-us/azure/application-gateway/for-containers/overview
