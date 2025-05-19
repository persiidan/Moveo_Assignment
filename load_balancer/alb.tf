resource "aws_security_group" "ALB_sg" {
  description = "Allow HTTP inbound traffic"   
  vpc_id = var.vpc_id
  name = "ALB_sg"
}
resource "aws_vpc_security_group_egress_rule" "out_all" {
  description = "Allow all outbound traffic"
  security_group_id = aws_security_group.ALB_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  ip_protocol = -1
}
resource "aws_vpc_security_group_ingress_rule" "allow_http_traffic" {
  description = "Allow HTTP inbound traffic from internet"
  security_group_id = aws_security_group.ALB_sg.id
  cidr_ipv4 = "0.0.0.0/0"
  from_port = 80
  ip_protocol = "tcp"
  to_port = 80
}

resource "aws_lb" "alb" {
  name = "nginx-alb"
  load_balancer_type = "application"
  internal = false
  security_groups = [ aws_security_group.ALB_sg.id ]
  subnets = [ var.pub_subnet1,var.pub_subnet2 ]
}

resource "aws_lb_target_group" "alb_tg" {
  name = "nginx-tg"
  target_type = "instance"
  port = 80
  protocol = "HTTP"
  vpc_id = var.vpc_id

  health_check {
    protocol = "HTTP"
    port = "80"
    path = "/"
    interval = 30
    healthy_threshold = 3
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group_attachment" "tg_attach" {
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id = var.ec2_id
  port = "80"
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}
