resource "kubectl_manifest" "disk_pvc" {
  yaml_body = file("${path.module}/kubernetes_storage_disk_pvc.yaml")
}

resource "kubectl_manifest" "disk" {
  yaml_body = file("${path.module}/kubernetes_storage_disk.yaml")
}

resource "kubectl_manifest" "fileshare" {
  yaml_body = file("${path.module}/kubernetes_storage_fileshare.yaml")
}

