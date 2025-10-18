variable "app" {
  type    = string
  default = "MediSupply"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "cidr" {
  type    = string
  default = "10.42.0.0/16"
}

variable "az_count" {
  type    = number
  default = 2
}

# EKS

variable "cluster_version" {
  type        = string
  default     = "1.34"
  description = "Versión de Kubernetes para EKS"
}
variable "instance_type" {
  type        = string
  default     = "t3.small"
  description = "Tipo de instancia para el node group"
}
variable "min_size" {
  type        = number
  default     = 1
  description = "Tamaño mínimo del grupo de nodos"
}
variable "desired_size" {
  type        = number
  default     = 2
  description = "Tamaño deseado del grupo de nodos"
}
variable "max_size" {
  type        = number
  default     = 4
  description = "Tamaño máximo del grupo de nodos"
}
variable "ami_type" {
  type        = string
  default     = "AL2023_x86_64_STANDARD"
  description = "Tipo de AMI para los nodos del cluster EKS"
}


#ECR
variable "repos" {
  type    = list(string)
  default = ["users"]
}

# DynamoDB
variable "tables" {
  type = map(object({
    hash_key         = string
    range_key        = optional(string)
    attributes       = map(string)
    billing_mode     = optional(string, "PAY_PER_REQUEST")
    ttl_enabled      = optional(bool, false)
    ttl_attribute    = optional(string)
    stream_enabled   = optional(bool, false)
    stream_view_type = optional(string, "NEW_AND_OLD_IMAGES")
  }))
}

# Observability - Logs

# Logs / Observabilidad
variable "microservices" { type = list(string) }
variable "retention_in_days" {
  type    = number
  default = 30
}
variable "fluentbit_namespace" {
  type    = string
  default = "kube-system"
}

variable "fluentbit_sa_name" {
  type    = string
  default = "fluent-bit"
}