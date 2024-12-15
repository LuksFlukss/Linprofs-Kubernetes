locals {
  name        = "EKSCluster"
  clustername = "LoukaCluster"
  region      = "eu-central-1"

  vpc_cidr = "10.23.0.0/16"
  azs      = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  public_subnets    = ["10.23.1.0/24", "10.23.2.0/24"]
  private_subnets   = ["10.23.3.0/24", "10.23.4.0/24"]
  intra_subnets     = ["10.23.5.0/24", "10.23.6.0/24"]

  tags = {
    Example    = local.name
  }
}

module "vpc" {

  source  = "terraform-aws-modules/vpc/aws"
  version = "5.16.0"


  name = local.name
  cidr = local.vpc_cidr
  azs  = local.azs

  private_subnets     = local.private_subnets
  public_subnets      = local.public_subnets
  intra_subnets       = local.intra_subnets

  enable_dns_hostnames = true
  single_nat_gateway   = true
  enable_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.31.1"

  cluster_name       = var.cluster_name
  cluster_version    = "1.30"

  cluster_endpoint_public_access            = true
  enable_cluster_creator_admin_permissions  = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  eks_managed_node_group_defaults = {
    ami_type                              = "AL2_x86_64"
    attach_cluster_primary_security_group = true
  }

  eks_managed_node_groups = {

    kubernetes-cluster-wg-1 = {

      name = "node-group-1"

      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = ["t3.small"]
      capacity_type  = "SPOT"

    }
  }
} 