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
  type = string 
  default = "1.34" 
  description = "Versión de Kubernetes para EKS"
}
variable "instance_type" { 
  type = string 
  default = "t3.small" 
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

#ECR
variable "repos" {
  type    = list(string)
  default = ["users"]
}