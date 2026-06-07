provider "aws" {
  region = var.az
}


module "ec2_app" {
  source        = "./modules/ec2_app"
  ami_id        = var.ami_id
  subnet_id     = var.public_subnet_id[0]
  sg_id         = var.app_sg_id
  key_name      = var.key_name
  instance_count = 2
}



module "ec2_db" {
  source        = "./modules/ec2_db"
  ami_id        = var.ami_id
  subnet_id     = var.private_subnet_id
  sg_id         = var.db_sg_id
  key_name      = var.key_name
  nat_gateway_ip = module.nat.nat_ip
}

module "nat" {
  source            = "./modules/nat"
  vpc_id            = var.vpc_id
  subnet_id         = var.public_subnet_id[0]
  private_subnet_id = var.private_subnet_id
}

module "elb" {
  source      = "./modules/elb"
  subnet_ids  = var.public_subnet_id
  sg_id       = var.elb_sg_id
  target_ids  = module.ec2_app.instance_ids
  vpc_id      = var.vpc_id
}

output "public_ips" {
  value = module.ec2_app.public_ips
}

output "private_ips" {
  value = module.ec2_app.private_ips
}


