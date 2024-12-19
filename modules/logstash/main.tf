resource "helm_release" "logstash" {

  name       = var.release_name
  namespace  = var.namespace
  repository = var.chart_repository
  chart      = var.chart_name
  version    = var.chart_version

  depends_on = [var.es_module_dependency]

  set {
    name  = "elasticsearch.host"
    value = var.elasticsearch_host
  }

  set {
    name  = "elasticsearch.port"
    value = var.elasticsearch_port
  }

}