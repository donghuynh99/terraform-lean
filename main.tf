# main.tf (Root)
# This is the "root module" - it only calls child modules.
# Notice how clean and readable this is compared to before!

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  required_version = ">= 1.0"

  // comment this section and run init -migrate-state if you want copy state back to local
  # backend "s3" {
  #   bucket         = "terraform-learn-state-donghuynh"
  #   key            = "dev/terraform.tfstate"
  #   region         = "ap-southeast-1"
  #   dynamodb_table = "terraform-learn-lock"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = var.aws_region
}

# --------------------------------------------------
# MODULE: VPC
# Creates all networking resources
# --------------------------------------------------
module "vpc" {
  source = "./modules/vpc"

  project_name       = var.project_name
  environment        = var.environment
  aws_region         = var.aws_region
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
}

# --------------------------------------------------
# MODULE: EC2
# Creates the web server
# Note: subnet_id and security_group_id come from the VPC module output!
# --------------------------------------------------
module "ec2" {
  source = "./modules/ec2"

  project_name      = var.project_name
  environment       = var.environment
  instance_type     = var.instance_type
  subnet_id         = module.vpc.public_subnet_id    # ← Output từ module vpc
  security_group_id = module.vpc.security_group_id   # ← Output từ module vpc
}

# --------------------------------------------------
# MODULE: S3
# Creates the storage bucket
# --------------------------------------------------
module "s3" {
  source = "./modules/s3"

  project_name = var.project_name
  environment  = var.environment
}
