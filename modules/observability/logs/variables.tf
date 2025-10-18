variable "app"  { type = string }
variable "env"  { type = string }

# Lista de microservicios (debe coincidir con label app=... en los Deployments)
variable "microservices" { type = list(string) }

# Días de retención en CloudWatch
variable "retention_in_days" {
  type    = number
  default = 30
}

# ServiceAccount que usará Fluent Bit
variable "fluentbit_namespace" {
  type    = string
  default = "kube-system"
}
variable "fluentbit_sa_name" {
  type    = string
  default = "fluent-bit"
}

variable "oidc_provider_arn" {
  description = "ARN del OIDC provider del cluster EKS"
  type        = string
}

variable "oidc_issuer_url" {
  description = "URL del issuer OIDC del cluster EKS"
  type        = string
}
