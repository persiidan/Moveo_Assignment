variable "vpc_id" {
    type = string
    description = "the VPC id of the alb security group"
}
variable "ec2_id" {
    type = string
    description = "the ec2 id for the target group"
}
variable "pub_subnet1" {
    type = string
    description = "one of the subnets needed for alb"
}
variable "pub_subnet2" {
      type = string
    description = "the second one"
}