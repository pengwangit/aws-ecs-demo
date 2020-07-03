terraform {
  required_providers {
    aws = "~> 2.68"
  }
}

provider "aws" {
  region                  = var.region
  shared_credentials_file = "./demo_creds/creds"
  profile                 = "./demo_creds/config"
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
