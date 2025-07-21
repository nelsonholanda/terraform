# ALB Module

# Application Load Balancer
resource "aws_lb" "bia_alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids

  enable_deletion_protection = false

  tags = {
    Name        = var.alb_name
    Environment = "production"
    Project     = "bia"
  }
}

# Target Group
resource "aws_lb_target_group" "bia_tg" {
  name     = "bia-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 2
    interval            = 30
    matcher             = "200,302"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 3
  }

  tags = {
    Name        = "bia-tg"
    Environment = "production"
    Project     = "bia"
  }
}

# ALB Listener
resource "aws_lb_listener" "bia_listener" {
  load_balancer_arn = aws_lb.bia_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.bia_tg.arn
  }
}