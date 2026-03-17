# modules/s3/variables.tf

variable "project_name" {
  description = "Name prefix for the S3 bucket"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}
