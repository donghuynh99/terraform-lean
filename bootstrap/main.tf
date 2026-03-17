# bootstrap/main.tf
# This project creates the S3 bucket and DynamoDB table
# needed to store Terraform remote state.
#
# IMPORTANT: This runs ONCE with local state.
# After applying, the main project will use S3 as its backend.

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = ">= 1.0"
  # NOTE: No backend block here — state stays LOCAL intentionally!
  # You can't store the state of the thing that creates the state bucket
  # in that same bucket (chicken-and-egg problem).
}

provider "aws" {
  region = var.aws_region
}

# --------------------------------------------------
# S3 BUCKET — stores terraform.tfstate files
# --------------------------------------------------
resource "aws_s3_bucket" "terraform_state" {
  bucket = var.state_bucket_name

  # force_destroy = true allows deleting the bucket even if it has objects inside
  # (including versioned state files). Set to true only when you want to destroy.
  force_destroy = true

  tags = {
    Name      = "Terraform State Bucket"
    ManagedBy = "Terraform Bootstrap"
  }
}

# Enable versioning — every state change is saved as a version (backup!)
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption — state may contain secrets
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block all public access — state files should NEVER be public
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# --------------------------------------------------
# DYNAMODB TABLE — locks state during apply
# Prevents 2 people from applying at the same time
# --------------------------------------------------
resource "aws_dynamodb_table" "terraform_lock" {
  name         = var.lock_table_name
  billing_mode = "PAY_PER_REQUEST" # No need to provision capacity
  hash_key     = "LockID"          # Required field name for Terraform

  attribute {
    name = "LockID"
    type = "S" # String
  }

  tags = {
    Name      = "Terraform State Lock Table"
    ManagedBy = "Terraform Bootstrap"
  }
}
