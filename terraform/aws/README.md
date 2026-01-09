# AWS Infrastructure - Terraform

This directory contains Terraform configurations for deploying the application to AWS using ECS Fargate.

## Architecture

- **VPC**: Custom VPC with public and private subnets across 2 AZs
- **ALB**: Application Load Balancer for traffic distribution
- **ECS Fargate**: Serverless container orchestration
- **Security Groups**: Least-privilege network access
- **Secrets Manager**: Secure secrets storage
- **CloudWatch**: Logging and monitoring

## Prerequisites

1. AWS CLI configured with credentials
2. Terraform >= 1.0 installed
3. Docker images pushed to ECR

## Usage

### 1. Initialize Terraform

```bash
cd terraform/aws
terraform init
```

### 2. Create terraform.tfvars

```bash
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your values
```

### 3. Plan Infrastructure

```bash
terraform plan
```

### 4. Apply Infrastructure

```bash
terraform apply
```

### 5. Get Outputs

```bash
terraform output
```

## Outputs

- `alb_dns_name`: Load balancer DNS name
- `backend_url`: Backend API URL
- `frontend_url`: Frontend application URL
- `ecs_cluster_name`: ECS cluster name

## Cleanup

```bash
terraform destroy
```

## Module Structure

```
aws/
├── main.tf              # Root module
├── variables.tf         # Input variables
├── outputs.tf           # Output values
├── modules/
│   ├── vpc/            # VPC, subnets, NAT gateways
│   ├── security/       # Security groups
│   ├── alb/            # Application Load Balancer
│   ├── ecs/            # ECS cluster and services
│   └── secrets/        # Secrets Manager
```

## Cost Estimation

- NAT Gateway: ~$32/month per AZ (2 AZs = $64/month)
- ALB: ~$16/month + data transfer
- ECS Fargate: ~$30/month for 2 tasks (0.5 vCPU, 1GB RAM each)
- **Total**: ~$110/month

**Tip**: Use Fargate Spot for cost savings (up to 70% discount)
