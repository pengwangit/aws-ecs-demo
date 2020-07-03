resource "aws_cloudwatch_log_group" "nginx_log_group" {
  name = var.nginx_service
}

resource "aws_cloudwatch_log_group" "app_log_group" {
  name = var.app_service
}
