terraform {
  required_providers {
    aws  = "~> 2.68"
    null = "~> 2.1"
  }
}

provider "aws" {
  region = var.region
  # shared_credentials_file = "./demo_creds/creds"
  # profile                 = "./demo_creds/config"
}

module "vpc_resources" {
  source       = "./vpc_resources"
  project_name = var.project_name
}

module "ecs_cluster_ec2" {
  source                  = "./ecs_cluster_ec2"
  project_name            = var.project_name
  private_subnet_a_ecs_id = module.vpc_resources.private_subnet_a_ecs_id
  private_subnet_b_ecs_id = module.vpc_resources.private_subnet_b_ecs_id
  ecs_instance_ec2_sg_id  = module.vpc_resources.ecs_instance_ec2_sg_id
  public_subnet_a_id      = module.vpc_resources.public_subnet_a_id
  public_subnet_b_id      = module.vpc_resources.public_subnet_b_id
  alb_sg_id               = module.vpc_resources.alb_sg_id
  http_port               = module.vpc_resources.http_port
  vpc_id                  = module.vpc_resources.vpc_id
}

module "secrets_manager" {
  source            = "./secrets_manager"
  database_username = var.database_username
  database_name     = var.database_name
  database_password = var.database_password
}

module "rds" {
  source                  = "./rds"
  project_name            = var.project_name
  rds_sg_id               = module.vpc_resources.rds_sg_id
  private_subnet_a_rds_id = module.vpc_resources.private_subnet_a_rds_id
  private_subnet_b_rds_id = module.vpc_resources.private_subnet_b_rds_id
  database_name           = var.database_name
  database_username       = var.database_username
  database_password       = var.database_password
}

module "ecr" {
  source       = "./ecr"
  project_name = var.project_name
}

module "ecs_tasks_services" {
  source                 = "./ecs_tasks_services"
  project_name           = var.project_name
  region                 = var.region
  nginx_repository_url   = module.ecr.nginx_repository_url
  app_repository_url     = module.ecr.app_repository_url
  nginx_version_tag      = module.ecr.nginx_version_tag
  app_version_tag        = module.ecr.app_version_tag
  db_host                = module.rds.address
  db_secret_arn          = module.secrets_manager.db_secrets_arn
  db_secrets_kms_key_arn = module.secrets_manager.db_secrets_kms_key_arn
  ecs_target_group_arn   = module.ecs_cluster_ec2.ecs_target_group_arn
  ecs_cluster_id         = module.ecs_cluster_ec2.ecs_cluster_id
  ecs_cluster_name       = module.ecs_cluster_ec2.ecs_cluster_name
}
