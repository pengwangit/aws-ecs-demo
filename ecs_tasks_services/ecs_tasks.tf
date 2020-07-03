#
# ECS Task IAM resources
#

data "aws_iam_policy_document" "ecs_task_execution_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name_prefix        = format("%s_task_execution_role", var.project_name)
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_tasks_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "inline_policy" {
  statement {
    effect = "Allow"

    actions = [
      "kms:Decrypt",
      "secretsmanager:GetSecretValue",
    ]

    resources = [
      var.db_secret_arn,
      var.db_secrets_kms_key_arn
    ]
  }
}

resource "aws_iam_role_policy" "inline_policy" {
  name   = "extra_task_policy"
  role   = aws_iam_role.ecs_task_execution_role.id
  policy = data.aws_iam_policy_document.inline_policy.json
}

# Task definition

resource "aws_ecs_task_definition" "nginx_app_definition" {
  family             = format("%s_nginx_app_tasks", var.project_name)
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = templatefile(
    "${path.module}/task-definitions/ecs_task_nginx_app_service.tpl",
    { latest_nginx_image_url = format("%s:%s", var.nginx_repository_url, var.nginx_version_tag),
      latest_app_image_url   = format("%s:%s", var.app_repository_url, var.app_version_tag),
      region                 = var.region,
      db_host                = var.db_host,
      db_secret_arn          = var.db_secret_arn
      nginx_service          = var.nginx_service
      app_service            = var.app_service
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}
