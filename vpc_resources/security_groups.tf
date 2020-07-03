resource "aws_security_group" "alb_sg" {
  name        = format("%s_alb_sg", var.project_name)
  description = "Allow alb access from internet"
  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = [var.full_cidr_block]
  }

  ingress {
    from_port   = var.https_port
    to_port     = var.https_port
    protocol    = "tcp"
    cidr_blocks = [var.full_cidr_block]
  }

  egress {
    from_port   = var.any_ports
    to_port     = var.any_ports
    protocol    = "-1"
    cidr_blocks = [var.full_cidr_block]
  }

  vpc_id = aws_vpc.new_vpc.id

  tags = {
    name = format("%s_alb_sg", var.project_name)
  }
}

resource "aws_security_group" "ecs_instance_ec2_sg" {
  name        = format("%s_ecs_instance_ec2_sg", var.project_name)
  description = "Allow traffic from alb approved ranges"
  ingress {
    from_port       = var.ephemeral_port_32768
    to_port         = var.ephemeral_port_65535
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = var.any_ports
    to_port     = var.any_ports
    protocol    = "-1"
    cidr_blocks = [var.full_cidr_block]
  }

  vpc_id = aws_vpc.new_vpc.id

  tags = {
    Name = format("%s_ecs_instance_ec2_sg", var.project_name)
  }
}

resource "aws_security_group" "rds_sg" {
  name        = format("%s_rds_sg", var.project_name)
  description = "allow ecs to access rds"
  vpc_id      = aws_vpc.new_vpc.id

  # Allows traffic from the security group itself
  ingress {
    from_port = var.any_ports
    to_port   = var.any_ports
    protocol  = "-1"
    self      = true
  }

  # Allow traffic for TCP 5432 from ECS cluster
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_instance_ec2_sg.id]
  }

  # outbound internet access
  egress {
    from_port   = var.any_ports
    to_port     = var.any_ports
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
