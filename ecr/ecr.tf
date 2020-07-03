resource "aws_ecr_repository" "nginx" {
  name                 = format("%s_ecr_nginx", lower(var.project_name))
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "app" {
  name                 = format("%s_ecr_app", lower(var.project_name))
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "null_resource" "push_nginx" {
  triggers = {
    # always_run = timestamp()
    sha256_nginx_tag = sha256(var.nginx_version_tag)
  }

  provisioner "local-exec" {
    command     = "${path.module}/upload_images.sh -c ${var.nginx_code_path} -u ${aws_ecr_repository.nginx.repository_url} -t ${var.nginx_version_tag}"
    interpreter = ["bash", "-c"]
  }
}

resource "null_resource" "pull_app" {
  triggers = {
    # always_run = timestamp()
    sha256_app_tag = sha256(var.app_version_tag)
  }

  provisioner "local-exec" {
    command     = "${path.module}/pull_app_code.sh -c ${var.source_code_folder} -g ${var.app_git_url}"
    interpreter = ["bash", "-c"]
  }
}

resource "null_resource" "push_app" {
  triggers = {
    # always_run = timestamp()
    sha256_app_tag = sha256(var.app_version_tag)
  }

  provisioner "local-exec" {
    command     = "${path.module}/upload_images.sh -c ${var.app_code_path} -u ${aws_ecr_repository.app.repository_url} -t ${var.app_version_tag}"
    interpreter = ["bash", "-c"]
  }

  depends_on = [null_resource.pull_app]
}
