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

/* AWS VPC Mpdule*/
variable "vpc_name" {
  description = "Name of our VPC"
  type        = string
  default     = "my-vpc"
}