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

  backend "s3" {
    bucket = "jb-initial-test-tf-state"
    key    = "app.tfstate"
    region = "us-east-2"
  }
}

# Sets the local variables
locals {
  project = "st-tf-test"
  vpc_id = "vpc-006861bbc13a90884"
  subnet_ids = [
    "subnet-0498bb0d4805401ba",
    "subnet-0893e2d8f8f4c2e24"
  ]
}

variable "local_image" {
  type = string
}

# Pulls in data from the setup stage
data "aws_ecs_cluster" "cluster" {
  cluster_name = "${local.project}-cluster"
}

data "aws_lb" "alb" {
  name = "${local.project}-lb"
}

data "aws_vpc" "vpc" {
  id = local.vpc_id
}

# Creates ECR repo for docker image
module "container" {
  source = "../modules/container"

  name        = "${local.project}-image"
  project     = local.project
  local_image = var.local_image
}

# Creates ECS Task definition
module "task" {
  source = "../modules/service"

  name = "${local.project}-task"
  project = local.project
  image = "${module.container.repo_url}:latest"
  cluster_id = data.aws_ecs_cluster.cluster.id
  alb_arn = data.aws_lb.alb.arn
  vpc_id = data.aws_vpc.vpc.id
  subnet_ids = local.subnet_ids
}