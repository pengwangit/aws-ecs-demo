variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_a_cidr" {
  description = "CIDR for the Public Subnet a"
  default     = "10.0.1.0/24"
}

variable "public_subnet_b_cidr" {
  description = "CIDR for the Public Subnet b"
  default     = "10.0.2.0/24"
}

variable "private_subnet_a_ecs" {
  description = "CIDR for the Private Subnet a ECS Servers"
  default     = "10.0.3.0/24"
}

variable "private_subnet_b_ecs" {
  description = "CIDR for the Private Subnet b ECS Servers"
  default     = "10.0.4.0/24"
}

variable "private_subnet_a_rds" {
  description = "CIDR for the Private Subnet a RDS Servers"
  default     = "10.0.5.0/24"
}

variable "private_subnet_b_rds" {
  description = "CIDR for the Private Subnet b RDS Servers"
  default     = "10.0.6.0/24"
}

variable "availability_zones" {
  # No spaces allowed between az names!
  default = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
}

variable "full_cidr_block" {
  default = "0.0.0.0/0"
}

variable "http_port" {
  default = 80
}

variable "https_port" {
  default = 443
}

variable "psql_port" {
  default = 5432
}

variable "ephemeral_port_1024" {
  default = 1024
}

variable "ephemeral_port_32768" {
  default = 32768
}

variable "ephemeral_port_65535" {
  default = 65535
}

variable "any_ports" {
  default = 0
}

# variables from other modules
variable "project_name" {}
