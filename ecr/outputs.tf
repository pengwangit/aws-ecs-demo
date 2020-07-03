output "nginx_repository_url" {
  value = aws_ecr_repository.nginx.repository_url
}

output "app_repository_url" {
  value = aws_ecr_repository.app.repository_url
}

output "nginx_version_tag" {
  value = var.nginx_version_tag
}

output "app_version_tag" {
  value = var.app_version_tag
}
