locals {
  # Nombre final de la tabla: dynamodb-<micro>-medisupply-<env>
  table_names = { for micro, cfg in var.tables :
    micro => "dynamodb-${micro}-medisupply-${var.env}"
  }
}

# VPC Endpoint (Gateway) para DynamoDB: enruta PRIVADO dentro de la VPC
resource "aws_vpc_endpoint" "dynamodb" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.dynamodb"
  vpc_endpoint_type = "Gateway"

  # Asociado a las route tables PRIVADAS
  route_table_ids = var.private_route_table_ids

  tags = {
    App       = var.app
    Env       = var.env
    Component = "vpc-endpoint"
    managed   = "terraform"
  }
}

# Tablas DynamoDB
resource "aws_dynamodb_table" "table" {
  for_each = var.tables

  name         = local.table_names[each.key]
  billing_mode = each.value.billing_mode

  hash_key  = each.value.hash_key
  range_key = try(each.value.range_key, null)

  dynamic "attribute" {
    for_each = each.value.attributes
    content {
      name = attribute.key
      type = attribute.value # "S" | "N" | "B"
    }
  }

  stream_enabled   = try(each.value.stream_enabled, false)
  stream_view_type = try(each.value.stream_view_type, "NEW_AND_OLD_IMAGES")

  dynamic "ttl" {
    for_each = try(each.value.ttl_enabled, false) && try(each.value.ttl_attribute, null) != null ? [1] : []
    content {
      enabled        = true
      attribute_name = each.value.ttl_attribute
    }
  }

  depends_on = [aws_vpc_endpoint.dynamodb]

  tags = {
    App       = var.app
    Env       = var.env
    Component = "dynamodb"
    managed   = "terraform"
  }
}