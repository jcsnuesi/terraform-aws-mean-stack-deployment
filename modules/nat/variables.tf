variable "vpc_id" {
  description = "ID de la VPC"
  type        = string
}

variable "subnet_id" {
  description = "ID de la subred pública donde se colocará el NAT Gateway"
  type        = string
}

variable "private_subnet_id" {
  description = "ID de la subred privada que usará la tabla de rutas con NAT"
  type        = string
}
