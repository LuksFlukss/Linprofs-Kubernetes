# Outputs
output "eks_cluster_name" {
  description = "The name of the EKS cluster."
  value       = module.eks-cluster.cluster_name
}

output "eks_cluster_id" {
  description = "The ID of the EKS cluster."
  value       = module.eks-cluster.cluster_id
}

output "eks_cluster_endpoint" {
  description = "The endpoint of the EKS cluster."
  value       = module.eks-cluster.cluster_endpoint
}

output "eks_cluster_oidc_provider_arn" {
  description = "The OIDC provider ARN for the EKS cluster."
  value       = module.eks-cluster.oidc_provider_arn
}

output "ebs_csi_role_arn" {
  description = "IAM Role ARN for the EBS CSI driver."
  value       = module.ebs_csi_irsa_role.iam_role_arn
}

output "cluster_certificate_authority_data" {
  description = "Kubernetes CA Certificate Authortiy Data"
  value       = module.eks-cluster.cluster_certificate_authority_data
}