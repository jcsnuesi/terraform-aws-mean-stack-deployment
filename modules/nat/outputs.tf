output "nat_ip" {
  description = "IP pública del NAT Gateway"
  value       = aws_eip.nat_eip.public_ip
}
