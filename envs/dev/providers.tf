terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.29"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.14"
    }
  }
}

# 1️⃣ Provider de AWS
provider "aws" {
  region = var.region
}

# 2️⃣ Leer información del cluster, pero solo después de crearlo
data "aws_eks_cluster" "cluster" {
  name       = try(module.eks.cluster_name, null)
  depends_on = [module.eks]
}

# 3️⃣ Obtener token de autenticación del cluster (también depende del cluster)
data "aws_eks_cluster_auth" "cluster" {
  name       = try(module.eks.cluster_name, null)
  depends_on = [module.eks]
}

# 4️⃣ Providers de Kubernetes y Helm (esperan al cluster)
provider "kubernetes" {
  host                   = try(data.aws_eks_cluster.cluster.endpoint, null)
  cluster_ca_certificate = try(base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data), null)
  token                  = try(data.aws_eks_cluster_auth.cluster.token, null)
}

provider "helm" {
  kubernetes {
    host                   = try(data.aws_eks_cluster.cluster.endpoint, null)
    cluster_ca_certificate = try(base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data), null)
    token                  = try(data.aws_eks_cluster_auth.cluster.token, null)
  }
}