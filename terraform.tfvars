# terraform.tfvars
# Your actual variable values

aws_region         = "ap-southeast-1"  # Singapore (closest to Vietnam)
project_name       = "terraform-learn"
environment        = "dev"
vpc_cidr           = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"
instance_type      = "t2.micro"        # Free Tier eligible!
#test