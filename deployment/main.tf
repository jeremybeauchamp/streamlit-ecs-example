# Terraform configuration. Currently only used
# to lock the provider versions
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.46.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.2"
    }
  }
}

# Sets the local variables
locals {
  project = "st-tf-test"
}

# Creates the VPC used for the ECS cluster
module "vpc" {
  source = "./modules/vpc"

  project = local.project
}

# Creates the Load Balancer for the cluster
module "load_balancer" {
  source = "./modules/load_balancer"

  name    = "${local.project}-lb"
  project = local.project

  security_group_id = module.vpc.security_group_id
  subnet_ids        = module.vpc.subnet_ids
  vpc_id            = module.vpc.vpc_id
  port              = 80
}

# Creates the ECS cluster
module "cluster" {
  source = "./modules/cluster"

  name    = "${local.project}-cluster"
  project = local.project
}

# Creates ECR repo for docker image
module "container" {
  source = "./modules/container"

  name        = "${local.project}-image"
  project     = local.project
  local_image = "st-app:latest"
}