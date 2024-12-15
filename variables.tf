variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "cluster_name" {
  description = "Name of our AWS EKS Cluster"
  type        = string
  default     = "Louka_Clstr"
}