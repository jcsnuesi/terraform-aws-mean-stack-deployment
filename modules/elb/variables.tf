variable "subnet_ids" {
  description = "Subredes públicas donde se ubica el ALB"
  type        = list(string)
}

variable "sg_id" {
  description = "Security Group del Load Balancer"
  type        = string
}

variable "target_ids" {
  description = "IDs de las instancias Node.js a balancear"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC donde vive el Load Balancer"
  type        = string
}
