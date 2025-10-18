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
  ami_type      = var.ami_type
}


# Almacenamiento (DynamoDB)
module "storage" {
  source = "../../modules/storage"

  app    = var.app
  env    = var.env
  region = var.region

  vpc_id                  = module.vpc.vpc_id
  private_route_table_ids = module.vpc.private_route_tables

  tables = var.tables
}

# Observability - Logs
module "logs" {
  source     = "../../modules/observability/logs"
  depends_on = [module.eks]

  app = var.app
  env = var.env

  # Tablas (por si las usas como referencia de nombres, no es obligatorio)
  microservices     = var.microservices
  retention_in_days = var.retention_in_days

  # IRSA para Fluent Bit (salen del módulo EKS moderno)
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_issuer_url   = module.eks.oidc_provider

  # ServiceAccount de Fluent Bit (si usas otros nombres, cámbialos)
  fluentbit_namespace = var.fluentbit_namespace
  fluentbit_sa_name   = var.fluentbit_sa_name
}


