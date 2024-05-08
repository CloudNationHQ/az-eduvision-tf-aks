resource "kubectl_manifest" "blue" {
  yaml_body = <<YAML
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: blue
  namespace: ${kubernetes_namespace.default.metadata.0.name}
spec:
  parentRefs:
  - name: ${local.gateway_name}
    namespace: ${kubernetes_namespace.default.metadata.0.name}
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /blue
    filters:
    - type: URLRewrite
      urlRewrite:
        path:
          type: ReplacePrefixMatch
          replacePrefixMatch: /
    backendRefs:
    - name: blue
      port: 80
      YAML
}

resource "kubectl_manifest" "green" {
  yaml_body = <<YAML
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: green
  namespace: ${kubernetes_namespace.default.metadata.0.name}
spec:
  parentRefs:
  - name: ${local.gateway_name}
    namespace: ${kubernetes_namespace.default.metadata.0.name}
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /green
    filters:
    - type: URLRewrite
      urlRewrite:
        path:
          type: ReplacePrefixMatch
          replacePrefixMatch: /
    backendRefs:
    - name: green
      port: 80
      YAML
}
