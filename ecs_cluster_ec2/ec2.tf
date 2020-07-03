#
# ECS EC2 Instance IAM resources
#
data "aws_iam_policy_document" "ecs_instance_ec2_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ecs_instance_ec2_role" {
  name_prefix        = format("%s_ec2_service_role", var.project_name)
  assume_role_policy = data.aws_iam_policy_document.ecs_instance_ec2_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_instance_ec2_role_attachment" {
  role       = aws_iam_role.ecs_instance_ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_instance_ec2_instance_profile" {
  name = aws_iam_role.ecs_instance_ec2_role.name
  role = aws_iam_role.ecs_instance_ec2_role.name
}

# Launch configuration for auto scaling group

resource "aws_launch_configuration" "ecs_launch_configuration" {
  name_prefix          = format("%s-lc", var.project_name)
  image_id             = var.image_id
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.ecs_instance_ec2_instance_profile.name
  user_data            = format("#!/bin/bash\necho ECS_CLUSTER=%s > /etc/ecs/ecs.config", var.ecs_cluster_name)
  security_groups      = [var.ecs_instance_ec2_sg_id]

  root_block_device {
    volume_size = var.instance_root_volume_size
    volume_type = "gp2"
    encrypted   = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "asg" {
  name = format("%s-asg", var.project_name)

  launch_configuration = aws_launch_configuration.ecs_launch_configuration.name
  vpc_zone_identifier  = [var.private_subnet_a_ecs_id, var.private_subnet_b_ecs_id]
  max_size             = var.asg_max_size
  min_size             = var.asg_min_size
  desired_capacity     = var.asg_desired_size

  health_check_grace_period = var.health_check_grace_period
  health_check_type         = "ELB"

  lifecycle {
    create_before_destroy = true
  }
}
