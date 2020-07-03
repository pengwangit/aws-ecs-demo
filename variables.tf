variable "region" {
  type = string
}

variable "project_name" {
  type = string
}

variable "database_name" {
  type        = string
  description = "database_name"
}

variable "database_username" {
  type        = string
  description = "database_username"
}

variable "database_password" {
  type        = string
  description = "database_password"
}

# extract variable for fast demo set up

variable "nginx_version_tag" {}

variable "app_version_tag" {}

variable "app_git_url" {}

variable "multi_az" {}

variable "backup_retention_period" {}

variable "target_value" {}
