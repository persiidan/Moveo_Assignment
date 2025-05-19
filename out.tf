output "alb_dns" {
  value = module.load_balancer.ALB_DNS
  description = "the ALB dns name for ease-of-use (see it in the cli no need to check in web)"
}
