function aks-get-credentials_ {
    az aks get-credentials --resource-group "resource-group" --name "aks-cluster-name" --admin
}

function push-docker-image_ {
    docker build -t namespace/backendexample:tagname .
    docker push namespace/backendexample:tagname
}