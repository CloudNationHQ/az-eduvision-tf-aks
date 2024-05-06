# Exercise 220 nginx add-on - appgateway
## Goal of dit exercise
This exercise will provision a public Azure Kubernetes Service cluster, enables the application routing add-on and adds an application gateway.

## Steps
1. Copy `environment.tf.example` to `environment.tf` and fill in your personal settings
2. Run `terraform init`
3. Run `terraform apply`
4. Copy the public ip that is assigned to the ingress controller endpoint into the backend setting within application gateway.

## Things you can try
* Review the public ip of the application gateway's frontend and connect with http://_public_ip_/blue and http://_public_ip_/green
* Switch the application routing add-on to private and make it work.
