# image id can be retrived dynamically
variable "image_id" {
  description = "image for ecs instance"
  default     = "ami-0abf1b04f846837ea"
}

variable "instance_type" {
  description = "instance type for ecs instance."
  default     = "t2.micro"
}

variable "instance_root_volume_size" {
  description = "instance_root_volume_size."
  default     = 30
}

variable "asg_max_size" {
  description = "The max size for the autoscaling group for the cluster."
  default     = 8
}

variable "asg_min_size" {
  description = "The min size for the autoscaling group for the cluster."
  default     = 2
}

variable "asg_desired_size" {
  description = "The desired size for the autoscaling group for the cluster."
  default     = 2
}

variable "health_check_grace_period" {
  description = "The grace period for the autoscaling group for the cluster."
  default     = 300
}

variable "ecs_cluster_name" {
  description = "The name for the cluster."
  default     = "demo"
}

variable "project_name" {}
variable "private_subnet_a_ecs_id" {}
variable "private_subnet_b_ecs_id" {}
variable "public_subnet_a_id" {}
variable "public_subnet_b_id" {}
variable "ecs_instance_ec2_sg_id" {}
variable "alb_sg_id" {}
variable "http_port" {}
variable "vpc_id" {}
