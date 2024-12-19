resource "helm_release" "elasticsearch" {

  name          = var.release_name
  chart         = var.chart_name

  namespace     = var.namespace
  repository    = var.chart_repository
  version       = var.chart_version

  create_namespace = true

  set {
    name  = "global.defaultStorageClass"
    value = var.default_storage_class
  }

  set {
    name  = "master.masterOnly"
    value = var.masterOnly
  }

  set {
    name  = "data.replicaCount"
    value = var.replicacount_data
  }

  set {
    name  = "coordinating.replicaCount"
    value = var.replicacount_coordinating
  }

  set {
    name  = "global.kibanaEnabled"
    value = var.kibanaEnabled
  }

  set {
    name  = "kibana.service.type"
    value = var.kibana_service_type
  }

  set {
    name  = "kibana.service.port"
    value = var.kibana_service_port
  }
}