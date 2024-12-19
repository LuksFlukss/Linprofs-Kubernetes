output "es_configuration" {
  description = "List of values for es configuration"
  value = [
    "Release Name: ${var.release_name}",
    "Chart Name: ${var.chart_name}",
    "Namespace: ${var.namespace}",
    "Chart Repository: ${var.chart_repository}",
    "Chart Version: ${var.chart_version}"
  ]
}

output "es_service_port" {
  description = "ElasticSearch Service Port"
  value = var.service_port
}

output "es_release_name" {
  description = "ElasticSearch Release Name"
  value = var.release_name
}