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
}

variable "local_image" {
  type = string
}

# Creates ECR repo for docker image
module "container" {
  source = "../modules/container"

  name        = "${local.project}-image"
  project     = local.project
  local_image = var.local_image
}