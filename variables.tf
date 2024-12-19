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

/* AWS ELK Module*/
variable "kubectl_namespace" {
  description = "Namespace of ou kubectl"
  type        = string
  default     = "elk"
}

variable "bitnami_chart_repository" {
  description = "Bitanmi Helm chart repository"
  type        = string
  default     = "oci://registry-1.docker.io/bitnamicharts"
}