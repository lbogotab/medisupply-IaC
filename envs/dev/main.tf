module "vpc" {
  source   = "../../modules/network/vpc"
  app      = var.app
  env      = var.env
  cidr     = var.cidr
  az_count = var.az_count
}

module "ecr" {
  source = "../../modules/registry/ecr"
  app    = var.app
  env    = var.env
  repos  = var.repos
  scan_on_push = true
}