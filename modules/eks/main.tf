module "eks-cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.31.1"

  cluster_name       = var.cluster_name
  cluster_version    = var.cluster_version

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

  vpc_id                   = var.vpc_module.vpc_id
  subnet_ids               = var.vpc_module.private_subnet_ids
  control_plane_subnet_ids = var.vpc_module.intra_subnet_ids

  eks_managed_node_group_defaults = {
    ami_type                              = "AL2_x86_64"
  }

  eks_managed_node_groups = {

    kubernetes-cluster-wg-1 = {

      name = var.nodegroup_name

      min_size     = 2
      max_size     = 6
      desired_size = 4

      instance_types = var.instance_types
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
      provider_arn               = module.eks-cluster.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
}