variable "eks_module_dependency" {
  description = "Dependency on EKS module to ensure the cluster is ready"
  type        = any
}

variable "release_name" {
  description = "Helm release name"
  type        = string
  default     = "elasticsearch"
}

variable "namespace" {
  description = "Namespace to deploy Elasticsearch"
  type        = string
  default     = "my-elasticsearch"
}

variable "chart_repository" {
  description = "Helm chart repository URL"
  type        = string
  default     = "oci://registry-1.docker.io/bitnamicharts"
}

variable "chart_name" {
  description = "Helm chart name"
  type        = string
  default     = "elasticsearch"
}

variable "chart_version" {
  description = "Version of the Helm chart"
  type        = string
  default     = "21.3.23"
}

variable "service_type" {
  description = "Type of Kubernetes service (e.g., LoadBalancer)"
  type        = string
  default     = "LoadBalancer"
}

variable "service_port" {
  description = "Service port for Elasticsearch"
  type        = number
  default     = 9200
}

variable "storage_class" {
  description = "Kubernetes storage class to use for persistence"
  type        = string
  default     = "gp2"
}