variable "ami_id" {
  description = "AMI personalizada con MongoDB preinstalado"
  type        = string
}

variable "subnet_id" {
  description = "Subred privada donde irá MongoDB"
  type        = string
}

variable "sg_id" {
  description = "Security Group para MongoDB"
  type        = string
}

variable "key_name" {
  description = "Clave SSH para conectarse"
  type        = string
}

variable "nat_gateway_ip" {
  description = "IP pública del NAT Gateway (para salidas a internet)"
  type        = string
}
