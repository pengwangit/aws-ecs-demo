resource "aws_alb" "ecs_alb" {
  name               = format("%s-alb", var.project_name)
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = [var.public_subnet_a_id, var.public_subnet_b_id]

  # enable_deletion_protection = true

  tags = {
    Name = format("%s-alb", var.project_name)
  }
}

resource "aws_alb_target_group" "ecs_target_group" {
  name     = format("%s-ecs-tg", var.project_name)
  port     = var.http_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    matcher             = "200"
    path                = "/health-check"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }
}

resource "aws_alb_listener" "alb_listener" {
  load_balancer_arn = aws_alb.ecs_alb.arn
  port              = var.http_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.ecs_target_group.arn
    type             = "forward"
  }
}
