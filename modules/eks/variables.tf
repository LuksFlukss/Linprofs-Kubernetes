# Variables
variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
}

variable "cluster_version" {
  description = "The version of the EKS cluster."
  type        = string
}

variable "vpc_module" {
  description = "The ID of the VPC to associate with the cluster."
  type        = any
}

variable "instance_types" {
  description = "A list of types of instances to use for our workgroup"
  type        = list(string)
}

variable "capacity_type" {
  description = "The storage capacity of the nodegroup"
  type        = string
}

variable "nodegroup_name" {
  description = "The name of the Worker NodeGroup in our cluster"
  type        = string
}