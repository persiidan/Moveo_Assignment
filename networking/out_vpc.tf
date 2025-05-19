output "PRIVATE_SUBNET_AZ1_ID" {
  value = aws_subnet.private_az1.id
}
output "VPC_ID" {
  value = aws_vpc.moveo.id
}
output "VPC_CIDR" {
  value = aws_vpc.moveo.cidr_block
}

output "PUBLIC_ALB_SUBNET_ID" {
  value = aws_subnet.public_alb_subnet.id
}
output "PUBLIC_NAT_SUBNET_ID" {
  value = aws_subnet.public_nat_subnet.id
}
