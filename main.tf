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

/*
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
  enable_dns_support   = true
  single_nat_gateway   = true
  enable_nat_gateway   = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}
*/

module "vpc" {
  source = "./modules/vpc"

  cidr                  = "10.23.0.0/16"
  enable_dns_hostnames  = true
  name                  = var.vpc_name
  azs                   = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  public_subnets        = ["10.23.1.0/24", "10.23.2.0/24"]
  private_subnets       = ["10.23.3.0/24", "10.23.4.0/24"]
  intra_subnets         = ["10.23.5.0/24", "10.23.6.0/24"]
  enable_nat_gateway    = true
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.31.1"

  cluster_name       = var.cluster_name
  cluster_version    = "1.30"

  cluster_endpoint_public_access            = true
  enable_cluster_creator_admin_permissions  = true

   cluster_addons = {
    coredns                = {
      most_recent = true
    }
    eks-pod-identity-agent = {
      most_recent = true
    }
    kube-proxy             = {
      most_recent = true
    }
    vpc-cni                = {
      most_recent = true
    }
    aws-ebs-csi-driver = {
      service_account_role_arn = module.ebs_csi_irsa_role.iam_role_arn
      most_recent = true
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnet_ids
  control_plane_subnet_ids = module.vpc.intra_subnet_ids

  eks_managed_node_group_defaults = {
    ami_type                              = "AL2_x86_64"
  }

  eks_managed_node_groups = {

    kubernetes-cluster-wg-1 = {

      name = "node-group-1"

      min_size     = 2
      max_size     = 6
      desired_size = 4

      instance_types = ["t3.medium"]
      capacity_type  = "SPOT"

    }
  }
}

module "ebs_csi_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name             = "${var.cluster_name}-ebs-csi"
  attach_ebs_csi_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
}

module "elasticsearch" {
  source = "./modules/elasticsearch"

  release_name = "elasticsearch"
  namespace = "elk"
  chart_repository = "oci://registry-1.docker.io/bitnamicharts"
  chart_name = "elasticsearch"
  chart_version = "21.3.23"
  kibana_service_type = "LoadBalancer"
  service_port = "9200"
  kibana_service_port = "5061"

  eks_module_dependency     = module.eks

  storage_class             = "gp2"
  masterOnly                = "false"
  replicacount_data         = "0"
  replicacount_coordinating = "0"
  kibanaEnabled             = "true"
}

/*
module "kibana" {
  source              = "./modules/kibana"
  release_name        = "kibana"
  namespace           = "elk"
  chart_repository    = "oci://registry-1.docker.io/bitnamicharts"
  chart_name          = "kibana"
  chart_version       = "11.4.1"
  service_type        = "LoadBalancer"
  service_port        = 5601
  elasticsearch_host  = "elasticsearch"
  elasticsearch_port  = 9200
  kibana_username     = "elastic"
  kibana_password     = "linprofs"
  enable_ingress      = true
  ingress_host        = "kibana.linprofs.com"
  storage_class       = "gp2"
  es_module_dependency = module.elasticsearch
}
*/