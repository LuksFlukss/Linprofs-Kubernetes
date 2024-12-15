/* General Values*/

output "region" {
  description = "AWS region"
  value       = var.region
}

/* VPC Module */

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

/* EKS Module */

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = module.eks.cluster_security_group_id
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = module.eks.cluster_name
}

output "cluster_certificate_authority_data" {
  description = "Kubernetes CA Certificate Authortiy Data"
  value       = module.eks.cluster_certificate_authority_data
}

/*
output "elasticsearch_loadbalancer_ip" {
  value = data.kubernetes_service.elasticsearch.status[0].load_balancer[0].ingress[0].ip
  description = "The LoadBalancer IP address for the Elasticsearch service"
}
*/