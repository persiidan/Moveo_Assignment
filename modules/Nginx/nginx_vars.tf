variable "ec2_subnet_id" {
    type = string
    description = "the private subnet's id the ec2 will be on"
}

variable "vpc_id" {
    type = string
    description = "the VPC id of the ec2 security group"
}

variable "alb_sg_id" {
    type = string
    description = "the id of the alb sg, critical for security purposes"
}

variable "vpc_cidrBlock" {
    type = string
    description = "vpc's cidr block to allow internal ssh for managment purposes"
}

variable "key_name" {
  type = string
  description = "name of pem key to access the ec2 instance via ssh"
}