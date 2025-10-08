module "vpc" {
  source   = "../../modules/network/vpc"
  app      = var.app
  env      = var.env
  cidr     = var.cidr
  az_count = var.az_count
}

# EKS
module "eks" {
  source = "../../modules/compute/eks"

  app = var.app
  env = var.env

  cluster_version = var.cluster_version

  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  public_subnets  = module.vpc.public_subnets

  instance_type = var.instance_type
  min_size      = var.min_size
  desired_size  = var.desired_size
  max_size      = var.max_size
}