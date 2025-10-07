variable "app" {
  type    = string
  default = "MediSupply"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "cidr" {
  type    = string
  default = "10.42.0.0/16"
}

variable "az_count" {
  type    = number
  default = 2
}