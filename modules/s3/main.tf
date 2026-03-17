# modules/s3/main.tf
# S3 Module: manages object storage

# --------------------------------------------------
# RANDOM SUFFIX for globally unique bucket name
# --------------------------------------------------
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# --------------------------------------------------
# S3 BUCKET
# --------------------------------------------------
resource "aws_s3_bucket" "main" {
  bucket = "${var.project_name}-${var.environment}-${random_id.bucket_suffix.hex}"

  tags = {
    Name        = "${var.project_name}-bucket"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Block all public access (security best practice)
resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
