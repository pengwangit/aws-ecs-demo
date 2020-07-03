variable "nginx_service" {
  description = "nginx service log name"
  default     = "nginx-service"
}

variable "app_service" {
  description = "app service log name"
  default     = "app-service"
}

variable "service_asg_max_size" {
  description = "The max size for the autoscaling group for the service."
  default     = 8
}

variable "service_asg_min_size" {
  description = "The min size for the autoscaling group for the service."
  default     = 2
}

variable "target_value" {
  description = "The min size for the autoscaling group for the service."
  default     = 1
}

variable "project_name" {}
variable "region" {}
variable "nginx_repository_url" {}
variable "app_repository_url" {}
variable "nginx_version_tag" {}
variable "app_version_tag" {}
variable "db_host" {}
variable "db_secret_arn" {}
variable "db_secrets_kms_key_arn" {}
variable "ecs_target_group_arn" {}
variable "ecs_cluster_id" {}
variable "ecs_cluster_name" {}
