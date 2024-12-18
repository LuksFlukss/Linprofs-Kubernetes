
resource "terraform_data" "set_default_storageclass" {
  provisioner "local-exec" {
    command = <<EOT
      echo "Patching gp2 StorageClass to set it as default..."
      kubectl patch storageclass gp2 -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
    EOT
  }

  depends_on = [var.eks_module_dependency]
}

resource "helm_release" "elasticsearch" {

  name       = var.release_name
  namespace  = var.namespace
  repository = var.chart_repository
  chart      = var.chart_name
  version    = var.chart_version

  depends_on = [terraform_data.set_default_storageclass]
  create_namespace = true

  set {
    name  = "service.type"
    value = var.service_type
  }

  set {
    name  = "service.port"
    value = var.service_port
  }

  set {
    name  = "data.persistence.storageClass"
    value = var.storage_class
  }
}