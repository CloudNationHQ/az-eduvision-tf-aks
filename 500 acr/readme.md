# Exercise 500 acr
## Goal of this exercise
This exercise will provision a public Azure Kubernetes Service (AKS) cluster, an Azure container registry (ACR) and connects both.

## Steps
1. Copy `environment.tf.example` to `environment.tf` and fill in your personal settings
2. Run `terraform init`
3. Run `terraform apply`

## Things you can try
* Run a dockerfile build on the ACR:
    1. $ACR_Name = "youracrname"
    2. cd "Directory where dockerfile resides"
    3. az acr build --registry $ACR_Name --image your_repository:your_tag --subscription your_subscription .
* Get your own image running as a container on AKS. Some hints:
    * kubectl expose deployment nginx0-deployment --port=80 --target-port=80
    * kubectl port-forward svc/nginx0-deployment 8080:80

## References
* https://learn.microsoft.com/en-us/azure/aks/cluster-container-registry-integration