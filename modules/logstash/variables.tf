variable "es_module_dependency" {
  description = "Dependency on ES module to ensure the service is ready"
  type        = any
}

variable "release_name" {
  description = "Helm release name"
  type        = string
}

variable "namespace" {
  description = "Namespace to deploy Elasticsearch"
  type        = string
}

variable "chart_repository" {
  description = "Helm chart repository URL"
  type        = string
}

variable "chart_name" {
  description = "Helm chart name"
  type        = string
}

variable "chart_version" {
  description = "Version of the Helm chart"
  type        = string
}

variable "elasticsearch_host" {
  description = "The hostname or IP address of the Elasticsearch server. This is used to specify the location where the Elasticsearch service is running, allowing other services or applications to connect to it."
  type        = string
}

variable "elasticsearch_port" {
  description = "The port number on which the Elasticsearch service is exposed. This is typically 9200 for HTTP access but may vary depending on your configuration."
  type        = string
}