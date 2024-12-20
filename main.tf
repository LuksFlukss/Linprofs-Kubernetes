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
  source = "./modules/eks"

  cluster_name       = var.cluster_name
  cluster_version    = "1.30"
  instance_types     = ["t3.medium"]
  nodegroup_name     = "nodegroup-1"
  capacity_type      = "SPOT"
  vpc_module         = module.vpc
}

/*
module "ekss" {
  source = "./modules/eks"

  aws_private_subnet      = module.vpc.private_subnet_ids
  #  aws_public_subnet       = module.vpc.public_subnet_ids
  vpc_id                  = module.vpc.vpc_id
  cluster_name            = "module-eks"
  endpoint_public_access  = true
  endpoint_private_access = true
  public_access_cidrs     = ["0.0.0.0/0"]
  node_group_name         = "tyest"
  scaling_desired_size    = 4
  scaling_max_size        = 6
  scaling_min_size        = 2
  instance_types          = ["t3.medium"]
  key_pair                = "TestKeyPair"
}
*/

module "elasticsearch" {
  source = "./modules/elasticsearch"

  release_name              = "elasticsearch"
  namespace                 = var.kubectl_namespace
  chart_repository          = var.bitnami_chart_repository
  chart_name                = "elasticsearch"
  chart_version             = "21.4.0"
  service_port              = "9200"

  eks_module_dependency     = module.eks

  default_storage_class     = "gp2"
  masterOnly                = "false"
  replicacount_data         = "0"
  replicacount_coordinating = "0"

  kibanaEnabled             = "true"
  kibana_service_type       = "LoadBalancer"
  kibana_service_port       = "5061"
}

module "logstash" {
  source = "./modules/logstash"

  es_module_dependency      = module.elasticsearch
  release_name              = "logstash"
  namespace                 = var.kubectl_namespace
  chart_repository          = var.bitnami_chart_repository
  chart_name                = "logstash"
  chart_version             = "6.4.1"

  elasticsearch_host        = module.elasticsearch.es_release_name
  elasticsearch_port        = module.elasticsearch.es_service_port
}