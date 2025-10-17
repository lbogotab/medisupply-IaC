module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "eks-medisupply-${var.env}"
  cluster_version = var.cluster_version

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true

  # OIDC para ServiceAccounts (necesario para ALB Controller, ExternalDNS)
  enable_irsa = true

  eks_managed_node_groups = {
    default = {
      ami_type       = var.ami_type
      instance_types = [var.instance_type]

      min_size     = var.min_size
      desired_size = var.desired_size
      max_size     = var.max_size

      subnet_ids = var.private_subnets

      iam_role_additional_policies = {
        AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
      }

      tags = {
        App       = var.app
        Env       = var.env
        Component = "eks-nodegroup"
        managed   = "terraform"
      }
    }
  }

  tags = {
    App       = var.app
    Env       = var.env
    Component = "eks"
    managed   = "terraform"
  }
}
