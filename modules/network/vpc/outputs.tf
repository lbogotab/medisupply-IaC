output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "ID de la VPC MediSupply"
}

output "public_subnets" {
  value       = module.vpc.public_subnets
  description = "IDs de subredes públicas (para ALB/ingress)"
}

output "private_subnets" {
  value       = module.vpc.private_subnets
  description = "IDs de subredes privadas (para nodos EKS, etc.)"
}

output "public_route_tables" {
  value       = module.vpc.public_route_table_ids
  description = "Route tables de subredes públicas"
}

output "private_route_tables" {
  value       = module.vpc.private_route_table_ids
  description = "Route tables de subredes privadas"
}

output "igw_id" {
  value       = module.vpc.igw_id
  description = "Internet Gateway de la VPC"
}

output "natgw_ids" {
  value       = module.vpc.natgw_ids
  description = "NAT Gateway(s) creados para egress de privadas"
}