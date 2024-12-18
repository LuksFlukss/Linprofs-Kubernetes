variable "name" {
  description = "The name for the resource, such as the VPC name."
  type        = string
}

variable "cidr" {
  description = "The CIDR block for the VPC network (e.g., 10.0.0.0/16)."
  type        = string
}

variable "azs" {
  description = "A list of availability zones to deploy resources in (e.g., [\"us-west-2a\", \"us-west-2b\"])."
  type        = list(string)
}

/* 
  ================== Subnets ===================
*/
variable "public_subnets" {
  description = "A list of CIDR blocks for the public subnets in the VPC."
  type        = list(string)

  validation {
    condition     = length(var.public_subnets) >= 2
    error_message = "You must specify at least two public subnets."
  }
}

variable "private_subnets" {
  description = "A list of CIDR blocks for the private subnets in the VPC."
  type        = list(string)

  validation {
    condition     = length(var.private_subnets) >= 2
    error_message = "You must specify at least two private subnets."
  }
}

variable "intra_subnets" {
  description = "A list of CIDR blocks for internal subnets used for communication between services within the VPC."
  type        = list(string)

  validation {
    condition     = length(var.intra_subnets) >= 2
    error_message = "You must specify at least two intra subnets."
  }
}

variable "enable_dns_hostnames" {
  description = "Flag to enable or disable DNS hostnames for instances in the VPC."
  type        = bool
  default     = false
}

variable "enable_nat_gateway" {
  description = "Flag to enable or disable the creation of NAT Gateways in the VPC."
  type        = bool
  default     = false
}