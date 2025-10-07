variable "app" {
  type        = string
  description = "Nombre de la app (p. ej., MediSupply)"
}

variable "env" {
  type        = string
  description = "Ambiente"
}

variable "repos" {
  type        = list(string)
  description = "Lista de nombres lógicos de microservicios para crear repos ECR"
}

variable "scan_on_push" {
  type        = bool
  default     = true
  description = "Habilitar escaneo de vulnerabilidades al push"
}

variable "lifecycle_keep" {
  type        = number
  default     = 5
  description = "Cuántas imágenes mantener por repo (policy de ciclo de vida)"
}