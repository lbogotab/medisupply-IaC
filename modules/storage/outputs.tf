output "table_names" {
  description = "Mapa <micro> => nombre físico de la tabla"
  value       = { for k, v in aws_dynamodb_table.table : k => v.name }
}

output "table_arns" {
  description = "Mapa <micro> => ARN de la tabla"
  value       = { for k, v in aws_dynamodb_table.table : k => v.arn }
}

output "dynamodb_vpc_endpoint_id" {
  description = "ID del VPC Endpoint (Gateway) de DynamoDB"
  value       = aws_vpc_endpoint.dynamodb.id
}