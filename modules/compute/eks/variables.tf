variable "app" { type = string }
variable "env" { type = string }

variable "cluster_version" {
  type        = string
  default     = "1.34"
  description = "Versión de Kubernetes para EKS"
}

variable "vpc_id" {
  type        = string
  description = "ID de la VPC donde se desplegará el cluster"
}

variable "private_subnets" {
  type        = list(string)
  description = "IDs de subredes PRIVADAS para nodos/cluster"
}

variable "public_subnets" {
  type        = list(string)
  description = "IDs de subredes PÚBLICAS (útiles para ALB/Ingress)"
}

variable "instance_type" {
  type        = string
  default     = "t3.small"
  description = "Tipo de instancia para el node group"
}

variable "min_size" {
    type = number 
    default = 1 
    description = "Tamaño mínimo del grupo de nodos"
}

variable "desired_size" {
    type = number
    default = 2
    description = "Tamaño deseado del grupo de nodos"
}

variable "max_size" {
    type = number
    default = 4
    description = "Tamaño máximo del grupo de nodos"
}