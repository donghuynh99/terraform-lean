# modules/ec2/variables.tf

variable "project_name" {
  description = "Name prefix for all resources"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  description = "Subnet ID where EC2 will be launched (from VPC module)"
  type        = string
}

variable "security_group_id" {
  description = "Security Group ID to attach to EC2 (from VPC module)"
  type        = string
}
