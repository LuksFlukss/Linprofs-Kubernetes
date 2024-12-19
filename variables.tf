/* Providers*/
variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

/* AWS EKS Module*/
variable "cluster_name" {
  description = "Name of our AWS EKS Cluster"
  type        = string
  default     = "Louka_Clstr"
}

/* AWS VPC Module*/
variable "vpc_name" {
  description = "Name of our VPC"
  type        = string
  default     = "my-vpc"
}

/* Elastic Search Data*/
output "elasticsearch_url" {
  description = "The Elasticsearch URL exposed by the module"
  value       = module.elasticsearch.elasticsearch_url
}

output "elasticsearch_service_name" {
  description = "The name of the Elasticsearch service"
  value       = module.elasticsearch.elasticsearch_service_name
}