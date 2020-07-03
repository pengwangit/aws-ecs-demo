#
# From other modules
#

variable "project_name" {}

variable "source_code_folder" {
  default = "ecr/source_code/"
}

variable "nginx_code_path" {
  default = "ecr/source_code/nginx"
}

variable "app_code_path" {
  default = "ecr/source_code/TechTestApp"
}

variable "nginx_version_tag" {
  default = 1
}

variable "app_version_tag" {
  default = 1
}

variable "app_git_url" {
  default = "https://github.com/servian/TechTestApp.git"
}
