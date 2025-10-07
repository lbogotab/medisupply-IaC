data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, var.az_count)
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "vpc-${var.app}-${var.env}"
  cidr = var.cidr

  azs             = local.azs
  public_subnets  = [for i, _ in local.azs : cidrsubnet(var.cidr, 8, i)]
  private_subnets = [for i, _ in local.azs : cidrsubnet(var.cidr, 8, i + 16)]

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway   = true
  single_nat_gateway   = true
  one_nat_gateway_per_az = false

  create_igw = true

  map_public_ip_on_launch = true

  tags = {
    App        = var.app
    Env        = var.env
    Component  = "network"
    Managed  = "terraform"
  }
}