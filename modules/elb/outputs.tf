output "lb_dns" {
  description = "DNS del ALB para acceder a la app"
  value       = aws_lb.app_alb.dns_name
}
