output "repository_urls" {
  description = "Map de <micro> => URL del repo"
  value       = { for k, v in aws_ecr_repository.this : k => v.repository_url }
}

output "repository_arns" {
  description = "Map de <micro> => ARN del repo"
  value       = { for k, v in aws_ecr_repository.this : k => v.arn }
}