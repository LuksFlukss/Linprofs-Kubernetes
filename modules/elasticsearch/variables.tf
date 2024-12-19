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
  default     = "elk"
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

variable "kibana_service_type" {
  description = "Type of Kubernetes service (e.g., LoadBalancer)"
  type        = string
  default     = "LoadBalancer"
}

variable "service_port" {
  description = "Service port for Elasticsearch"
  type        = number
  default     = 9200
}

variable "default_storage_class" {
  description = "Kubernetes default storage class to use for persistence"
  type        = string
  default     = "gp2"
}

variable "masterOnly" {
  description = "Determines if the setup should be restricted to a master node only. Set to 'true' if the configuration is meant for a single-node setup, or 'false' for a multi-node or replica setup."
  type        = string
  default     = "false"
}

variable "replicacount_data" {
  description = "The number of replica pods to be deployed for data storage. This determines how many replica pods will be created for handling persistent storage for the application data (e.g., Elasticsearch data). Set to '0' if no replicas are required."
  type        = string
  default     = "0"
}

variable "replicacount_coordinating" {
  description = "The number of replica pods to be deployed for coordinating nodes. This setting controls the number of coordinating node replicas, which typically handle requests from clients and manage the cluster. Set to '0' if no coordinating replicas are needed."
  type        = string
  default     = "0"
}

variable "kibanaEnabled" {
  description = "Indicates whether Kibana should be enabled or deployed in the cluster. Set to 'true' to enable Kibana for visualizing Elasticsearch data, or 'false' to disable Kibana."
  type        = string
  default     = "true"
}


variable "kibana_service_port" {
  description = "Service port for Kibana"
  type        = string
  default     = "5061"
}