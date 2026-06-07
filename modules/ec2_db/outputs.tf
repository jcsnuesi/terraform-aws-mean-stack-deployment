output "private_ip" {
  description = "IP privada del servidor MongoDB"
  value       = aws_instance.mongodb.private_ip
}

output "instance_id" {
  value = aws_instance.mongodb.id
}
