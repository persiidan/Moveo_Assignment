output "private_subnet_az1_id" {
  value = aws_subnet.private_az1.id
}
output "vpc_id" {
  value = aws_vpc.moveo.id
}
output "vpc_cidr" {
  value = aws_vpc.moveo.cidr_block
}

output "public_alb_subnet_id" {
  value = aws_subnet.public_alb_subnet.id
}
output "public_nat_subnet_id" {
  value = aws_subnet.public_nat_subnet.id
}
