# 🚀 Terraform Learn — AWS Infrastructure

[![Terraform CI/CD](https://github.com/<your-username>/terraform-learn/actions/workflows/terraform.yml/badge.svg)](https://github.com/<your-username>/terraform-learn/actions)

A learning project for Terraform on AWS, structured with **modules** and **remote state**.

## 📁 Project Structure

```
.
├── main.tf              # Root module — calls all child modules
├── variables.tf         # Input variables
├── outputs.tf           # Output values
├── terraform.tfvars     # Variable values
├── bootstrap/           # Creates S3 + DynamoDB for remote state (run once)
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
└── modules/
    ├── vpc/             # VPC, Subnet, IGW, Route Table, Security Group
    ├── ec2/             # EC2 Instance
    └── s3/              # S3 Bucket
```

## 🏗️ Infrastructure

| Resource | Details |
|---|---|
| VPC | `10.0.0.0/16` with public subnet |
| EC2 | `t2.micro` with Apache web server |
| S3 | Private bucket with versioning |
| State | Stored in S3 + DynamoDB lock |

## 🚀 Getting Started

### Prerequisites
- [Terraform >= 1.0](https://developer.hashicorp.com/terraform/downloads)
- [AWS CLI](https://aws.amazon.com/cli/) configured with credentials
- AWS account (Free Tier eligible)

### 1. Setup Remote State (run once)
```bash
cd bootstrap
terraform init
terraform apply
cd ..
```

### 2. Deploy Infrastructure
```bash
terraform init
terraform plan
terraform apply
```

### 3. Destroy
```bash
terraform destroy
```

## 🔄 CI/CD

| Trigger | Action |
|---|---|
| Pull Request to `main` | `fmt check` + `validate` + `plan` (posted as PR comment) |
| Merge to `main` | `plan` + `apply` automatically |

## 🔑 GitHub Secrets Required

| Secret | Description |
|---|---|
| `AWS_ACCESS_KEY_ID` | AWS Access Key |
| `AWS_SECRET_ACCESS_KEY` | AWS Secret Key |
