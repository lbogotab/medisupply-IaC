output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "oidc_provider" {
  description = "Issuer URL del OIDC provider del cluster EKS"
  value       = module.eks.oidc_provider
}

output "node_group_names" {
  value = keys(module.eks.eks_managed_node_groups)
}