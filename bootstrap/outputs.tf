# bootstrap/outputs.tf

output "state_bucket_name" {
  description = "S3 bucket name for Terraform state — copy this to main project backend config"
  value       = aws_s3_bucket.terraform_state.bucket
}

output "state_bucket_arn" {
  description = "ARN of the S3 state bucket"
  value       = aws_s3_bucket.terraform_state.arn
}

output "lock_table_name" {
  description = "DynamoDB table name for state locking — copy this to main project backend config"
  value       = aws_dynamodb_table.terraform_lock.name
}

output "backend_config" {
  description = "Copy this backend block into your main project's main.tf"
  value       = <<-EOT

    # ===== COPY THIS INTO main.tf =====
    terraform {
      backend "s3" {
        bucket         = "${aws_s3_bucket.terraform_state.bucket}"
        key            = "dev/terraform.tfstate"
        region         = "${aws_s3_bucket.terraform_state.region}"
        dynamodb_table = "${aws_dynamodb_table.terraform_lock.name}"
        encrypt        = true
      }
    }
    # ==================================
  EOT
}
