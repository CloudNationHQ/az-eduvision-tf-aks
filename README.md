# eduvision-tf-aks

## Cheat Sheet

### AZ Cli Tips

Loggin in with az cli

```
az login --use-device-code --tenant $your-tenant
```

Setting the correct subscription
```
az account set --subscription $subscription-name
```
or
```
az account set --subscription $subscription-id
```

Merging AKS credentials in current Kube config
```
az aks get-credentials --resource-group $resourceGroup --name $clusterName --overwrite-existing
```

### Terraform

set terraform alias
linux / mac
Add this to your `~/.bashrc` or `~/.zshrc` file
```
#terraform alias
alias tf="terraform"
```
windows/powershell
Add this to your `$profile` file
```
#terraform alias
Set-Alias -Name tf -Value terraform
```

Initialize a terraform working directory
```
tf init
```
Make a plan of the resources you want to create
```
tf plan
```
Make a plan of the resources you want to create and prompt for creation:
```
tf apply
```

Destroy all resources defined in the terraform state
```
tf destroy
```

Show all resources in the terraform state
```
tf state list
```

Delete a resource in the terraform state
```
tf state rm $resourcename
```

Create a Json terraform plan to be used for [pretty plan](https://cloudandthings.github.io/terraform-pretty-plan/)
```
terraform plan -out=plan.out
terraform show -json plan.out > plan.json
```

### ctl

Auto Completion
bash:
```
source /usr/share/bash-completion/bash_completion
echo 'source <(kubectl completion bash)' >>~/.bashrc
```

windows:
```
kubectl completion powershell | Out-String | Invoke-Expression
kubectl completion powershell >> $PROFILE
```
Get a list of all services
```
kubectl get svc -A
```
Get a list of all services with details
```
kubectl describe svc -A
```

Get a list of all ingresses
```
kubectl get ingress -A
```
Get a list of all ingresses with details
```
kubectl describe ingress -A
```