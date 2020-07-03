variable "allocated_storage" {
  description = "allocated_storage"
  default     = 10
}

variable "max_allocated_storage" {
  description = "max_allocated_storage"
  default     = 100
}

variable "engine" {
  description = "postgres"
  default     = "postgres"
}

variable "engine_version" {
  description = "engine_version"
  default     = "10.7"
}

variable "instance_class" {
  description = "instance_class"
  default     = "db.t2.micro"
}

# set to false to speed up demo provision
variable "multi_az" {
  description = "multi_az"
  default     = false
}

variable "backup_retention_period" {
  description = "backup_retention_period"
  default     = 7
}

variable "project_name" {}
variable "rds_sg_id" {}
variable "private_subnet_a_rds_id" {}
variable "private_subnet_b_rds_id" {}
variable "database_name" {}
variable "database_username" {}
variable "database_password" {}
