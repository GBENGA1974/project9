# APPLICATION LOAD BALANCER
# terraform create application load balancer

# APPLICATION LOAD BALANCER

resource "aws_lb" "project9-alb" {
  name = "project9-alb"
  internal = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.PROJECT9-vpc-security-group.id, aws_security_group.project9-DB-secgrp.id]

  enable_deletion_protection = false

    subnet_mapping {
    subnet_id     = aws_subnet.project9-pubsubnet1.id
  }

  subnet_mapping {
    subnet_id     = aws_subnet.project9-pubsubnet2.id
  }

  tags = {
    name = "PROJECT9-alb"
  }
}

# TARGET GROUP

resource "aws_alb_target_group" "PROJECT9_alb_target_group" {
  name        = "project9-tg"
  target_type = "instance"
  protocol    = "HTTP"
  port        = 80
  vpc_id      = aws_vpc.PROJECT9-VPC.id

  health_check {
    healthy_threshold   = 5
    interval            = 30
    matcher             = "300"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
}

# LISTENER ON PORT 80 WITH REDIRECT APPLICATION

resource "aws_lb_listener" "PROJECT9-alb-listener" {
  load_balancer_arn = aws_lb.project9-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.PROJECT9_alb_target_group.arn
    type             = "forward"
  }
}