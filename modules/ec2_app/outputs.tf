output "instance_ids" {
  description = "IDs de las instancias app"
  value       = aws_instance.app_node[*].id
}

output "public_ips" {
  description = "IPs públicas de las instancias app"
  value       = aws_instance.app_node[*].public_ip
}

output "private_ips" {
  description = "IPs privadas de las instancias app"
  value       = aws_instance.app_node[*].private_ip
}
