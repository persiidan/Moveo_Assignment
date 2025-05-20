module "networking" {
  source = "./modules/networking"
  region = var.region
}

module "nginx" {
  source = "./modules/Nginx"
  app_port = var.app_port
  ec2_subnet_id = module.networking.private_subnet_az1_id
  vpc_id = module.networking.vpc_id
  alb_sg_id = module.load_balancer.alb_sg_id
  vpc_cidr = module.networking.vpc_cidr
  key_name = "terra_key"
}

module "load_balancer" {
  source = "./modules/load_balancer"
  vpc_id = module.networking.vpc_id
  ec2_id = module.nginx.instance_id
  pub_subnet1 = module.networking.public_alb_subnet_id
  pub_subnet2 = module.networking.public_nat_subnet_id
}