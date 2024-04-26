function aks-get-credentials_ {
    az aks get-credentials --resource-group "resource-group" --name "aks-cluster-name" --admin
    kubelogin convert-kubeconfig -l azurecli
}

function push-docker-image_ {
    docker build -t namespace/backendexample:tagname .
    docker push namespace/backendexample:tagname
}