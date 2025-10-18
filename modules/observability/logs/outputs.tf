output "log_group_names" {
  description = "Mapa microservicio -> nombre de Log Group"
  value       = { for k, v in aws_cloudwatch_log_group.svc : k => v.name }
}

output "fluentbit_role_arn" {
  description = "ARN del rol IRSA para el ServiceAccount fluent-bit"
  value       = aws_iam_role.fluentbit.arn
}