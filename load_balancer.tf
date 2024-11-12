# Application Load Balancer (ALB)
resource "aws_lb" "main" {
  name               = "web-server-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]
  subnets            = [aws_subnet.main_a.id, aws_subnet.main_b.id]  # Verwendet beide Subnetze in verschiedenen AZs
  enable_deletion_protection = false

  enable_cross_zone_load_balancing = true

  tags = {
    Name = "WebServerLB"
  }
}

# Zielgruppe für den Load Balancer (Target Group)
resource "aws_lb_target_group" "main" {
  name     = "web-server-targets"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    interval            = 30
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
    healthy_threshold   = 2
  }

  tags = {
    Name = "WebServerTargetGroup"
  }
}

# Listener für den Load Balancer
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}
