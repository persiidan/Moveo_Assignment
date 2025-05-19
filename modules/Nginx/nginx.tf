resource "aws_security_group" "Nginx" {
  vpc_id = var.vpc_id
  name = "nginx_sg"
  description = "security for nginx server"
}

resource "aws_vpc_security_group_ingress_rule" "allow_only_alb" {
  description = "Allow HTTP inbound traffic from ALB"
  security_group_id = aws_security_group.Nginx.id
  referenced_security_group_id = var.alb_sg_id
  from_port = var.app_port
  ip_protocol = "tcp"
  to_port = var.app_port
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_from_vpc" {
  description = "Allow SSH inbound traffic from VPC only"
  security_group_id = aws_security_group.Nginx.id
  cidr_ipv4 = var.vpc_cidrBlock
  from_port = 22
  ip_protocol = "tcp"
  to_port = 22
}

resource "aws_vpc_security_group_egress_rule" "out_all" {
  security_group_id = aws_security_group.Nginx.id
  description = "Allow all outbound traffic"
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = -1
}

resource "aws_instance" "nginx" { 
  ami = "ami-09b5106eeaaad79ec"
  instance_type = "t3.micro"
  subnet_id = var.ec2_subnet_id
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.Nginx.id]
  
  tags = {
    Name = "Web-Nginx"
  }

  user_data_replace_on_change = true
  user_data_base64 = filebase64("${path.module}/user_data.sh")
}