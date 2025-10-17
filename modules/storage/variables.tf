variable "app" { type = string }    # "MediSupply"
variable "env" { type = string }    # "dev" | "prod"
variable "region" { type = string } # "us-east-1", etc.

# VPC endpoint (Gateway) necesita VPC y route tables privadas
variable "vpc_id" {
  type        = string
  description = "ID de la VPC donde se creará el VPC Endpoint de DynamoDB"
}

variable "private_route_table_ids" {
  type        = list(string)
  description = "IDs de route tables PRIVADAS para asociar el endpoint de DynamoDB"
}

# Definición de tablas por microservicio.
# Clave del mapa = nombre lógico del micro (p.ej., "orders", "products")
# Campos mínimos: hash_key, attributes (map nombre => tipo: S|N|B)
# Opcionales: range_key, billing_mode, ttl_enabled, ttl_attribute, stream_enabled, stream_view_type
variable "tables" {
  type = map(object({
    hash_key         = string
    range_key        = optional(string)
    attributes       = map(string)                         # "id" = "S", "ts" = "N", etc.
    billing_mode     = optional(string, "PAY_PER_REQUEST") # o "PROVISIONED"
    ttl_enabled      = optional(bool, false)
    ttl_attribute    = optional(string, null)
    stream_enabled   = optional(bool, false)
    stream_view_type = optional(string, "NEW_AND_OLD_IMAGES") # si se habilita stream
  }))
  description = "Mapa de definiciones de tablas por microservicio"
}