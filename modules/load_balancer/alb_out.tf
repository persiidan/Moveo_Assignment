output "ALB_SG_ID" {
  value = aws_security_group.ALB_sg.id
}
output "ALB_DNS" {
  value = aws_lb.alb.dns_name
}