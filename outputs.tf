output "app_public_ips" {
  value = module.ec2_app.public_ips
}

output "app_private_ips" {
  value = module.ec2_app.private_ips
}

output "db_private_ip" {
  value = module.ec2_db.private_ip
}

output "alb_dns" {
  value = module.elb.lb_dns
}

output "nat_ip" {
  value = module.nat.nat_ip
}
