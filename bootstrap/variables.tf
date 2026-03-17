# bootstrap/variables.tf

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "state_bucket_name" {
  description = "Name of the S3 bucket to store Terraform state. Must be globally unique!"
  type        = string
  default     = "terraform-learn-state-donghuynh" # ← Đổi tên này thành tên của bạn!
}

variable "lock_table_name" {
  description = "Name of the DynamoDB table for state locking"
  type        = string
  default     = "terraform-learn-lock"
}
