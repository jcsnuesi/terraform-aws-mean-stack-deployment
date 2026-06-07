variable "ami_id" {
  description = "AMI personalizada que contiene la app con NGINX + Node.js"
  type        = string
}

variable "subnet_id" {
  description = "Subred pública donde desplegar las instancias"
  type        = string
}

variable "sg_id" {
  description = "Security Group ya creado para los nodos app"
  type        = string
}

variable "key_name" {
  description = "Nombre de la clave SSH para acceder a las instancias"
  type        = string
}

variable "instance_count" {
  description = "Cantidad de instancias app a desplegar"
  type        = number
  default     = 2
}
