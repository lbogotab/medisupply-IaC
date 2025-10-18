resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-medisupply-${var.env}-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "EKSClusterAssumeRoleService"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
      {
        Sid = "AllowUserAlejo"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::726264870413:user/Alejo"
        }
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })
}

# Políticas necesarias para que el rol funcione correctamente con EKS
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_vpc_controller" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "eks-medisupply-${var.env}"
  cluster_version = var.cluster_version
  vpc_id          = var.vpc_id
  subnet_ids      = var.private_subnets

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  enable_irsa                     = true

  # 👇 Usa tu propio rol (el que definiste arriba)
  iam_role_arn = aws_iam_role.eks_cluster_role.arn

  eks_managed_node_groups = {
    default = {
      ami_type       = var.ami_type
      instance_types = [var.instance_type]
      min_size       = var.min_size
      desired_size   = var.desired_size
      max_size       = var.max_size
      subnet_ids     = var.private_subnets

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