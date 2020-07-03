#
# ECS Service IAM resources
#

data "aws_iam_policy_document" "ecs_service_execution_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_service_execution_role" {
  name_prefix        = format("%s_srv_execution_role", var.project_name)
  assume_role_policy = data.aws_iam_policy_document.ecs_service_execution_role.json
}

resource "aws_iam_role_policy_attachment" "ecs-service-role-attachment" {
  role       = aws_iam_role.ecs_service_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

resource "aws_ecs_service" "nginx_app_service" {
  name            = format("%s_nginx_app_service", var.project_name)
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.nginx_app_definition.arn
  desired_count   = 2
  iam_role        = aws_iam_role.ecs_service_execution_role.arn

  load_balancer {
    target_group_arn = var.ecs_target_group_arn
    container_name   = "nginx"
    container_port   = 80
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "instanceId"
  }
}

#
# Application AutoScaling resources
#
resource "aws_appautoscaling_target" "nginx_app_service_target" {
  resource_id        = format("service/%s/%s", var.ecs_cluster_name, aws_ecs_service.nginx_app_service.name)
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  min_capacity       = var.service_asg_min_size
  max_capacity       = var.service_asg_max_size

  depends_on = [
    aws_ecs_service.nginx_app_service,
  ]
}

resource "aws_appautoscaling_policy" "ecs_policy" {
  name               = "nginx_app_service_scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.nginx_app_service_target.resource_id
  scalable_dimension = aws_appautoscaling_target.nginx_app_service_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.nginx_app_service_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value = var.target_value
  }
}
