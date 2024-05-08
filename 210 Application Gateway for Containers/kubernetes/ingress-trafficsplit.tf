resource "kubectl_manifest" "ingress" {
  yaml_body = <<YAML
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: traffic-split-route
  namespace: ${kubernetes_namespace.default.metadata.0.name}
spec:
  parentRefs:
  - name: ${local.gateway_name}
  rules:
  - backendRefs:
    - name: blue
      port: 80
      weight: 50
    - name: green
      port: 80
      weight: 50
      YAML
}
