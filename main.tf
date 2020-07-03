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
