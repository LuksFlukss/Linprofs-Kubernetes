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
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
    aws-ebs-csi-driver = {
      service_account_role_arn = module.ebs_csi_irsa_role.iam_role_arn
      most_recent = true
    }
  }

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  eks_managed_node_group_defaults = {
    ami_type                              = "AL2_x86_64"
    # attach_cluster_primary_security_group = true #Double secruity groups with same tag issue
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

resource "terraform_data" "set_default_storageclass" {
  provisioner "local-exec" {
    command = <<EOT
      echo "Patching gp2 StorageClass to set it as default..."
      kubectl patch storageclass gp2 -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
    EOT
  }

  depends_on = [module.eks]
}

resource "helm_release" "elasticsearch" {
  name       = "elasticsearch"
  namespace  = "my-elasticsearch"
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "elasticsearch"
  version    = "21.3.23"

  create_namespace = true

  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "service.port"
    value = "9200"
  }

  set {
    name  = "data.persistence.storageClass"
    value = "gp2"
  }
}

/*
resource "helm_release" "nginx" {
  name       = "nginx"
  namespace  = "default"
  repository = "oci://registry-1.docker.io/bitnamicharts"
  chart      = "nginx"
  # depends_on = [module.eks.eks_managed_node_groups]
  #timeout    = 1000

  values = [
    # Override default NGINX values if necessary
    <<EOF
    replicaCount: 2
    image:
      tag: "latest"
    service:
      type: LoadBalancer
    EOF
  ]
}
*/