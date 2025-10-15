output "alb_dns" {
  value       = module.load_balancer.alb_dns
  description = "the ALB dns name for ease-of-use (see it in the cli no need to check in web)"
}
