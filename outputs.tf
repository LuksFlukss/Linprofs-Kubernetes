/* General Values*/

output "region" {
  description = "Active AWS Region"
  value       = var.region
}

/* VPC Module */
output "vpc_id" {
  description = "VPC_ID"
  value       = module.vpc.vpc_id
}

/* EKS Module */
output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

/*
output "cluster_certificate_authority_data" {
  description = "Kubernetes CA Certificate Authortiy Data"
  value       = module.eks.cluster_certificate_authority_data
}
*/

/* Elastic Search Data*/
output "es_configuration" {
  description = "The Elasticsearch URL exposed by the module"
  value       = module.elasticsearch.es_configuration
}