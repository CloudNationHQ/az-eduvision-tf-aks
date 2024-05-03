function aks-get-credentials_ {
    # Only works with local accounts enabled:
    # az aks get-credentials --resource-group "resource-group" --name "aks-cluster-name" --admin
    az aks get-credentials --resource-group "resource-group" --name "aks-cluster-name" --subscription "subscription-id"
    kubelogin convert-kubeconfig --login azurecli
}

function push-docker-image_ {
    docker build -t namespace/backendexample:tagname .
    docker push namespace/backendexample:tagname
}