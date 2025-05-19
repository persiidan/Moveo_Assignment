module "networking" {
  source = "./modules/networking"
}

module "nginx" {
  source = "./modules/Nginx"
  ec2_subnet_id = module.networking.PRIVATE_SUBNET_AZ1_ID
  vpc_id = module.networking.VPC_ID
  alb_sg_id = module.load_balancer.ALB_SG_ID
  vpc_cidrBlock = module.networking.VPC_CIDR
  key_name = "terra_key"
}

module "load_balancer" {
  source = "./modules/load_balancer"
  vpc_id = module.networking.VPC_ID
  ec2_id = module.nginx.INSTANCE_ID
  pub_subnet1 = module.networking.PUBLIC_ALB_SUBNET_ID
  pub_subnet2 = module.networking.PUBLIC_NAT_SUBNET_ID
}