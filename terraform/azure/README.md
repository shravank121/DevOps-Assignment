# Azure Infrastructure - Terraform

This directory contains Terraform configurations for deploying the application to Azure using Container Apps.

## Architecture

- **Resource Group**: Container for all resources
- **VNet**: Virtual network with subnet
- **Container Apps Environment**: Managed environment for containers
- **Container Apps**: Backend and frontend services with auto-scaling
- **Key Vault**: Secure secrets storage
- **Log Analytics**: Centralized logging and monitoring

## Prerequisites

1. Azure CLI configured with credentials
2. Terraform >= 1.0 installed
3. Docker images pushed to Azure Container Registry

## Usage

### 1. Initialize Terraform

```bash
cd terraform/azure
terraform init
```

### 2. Create terraform.tfvars

```bash
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your ACR credentials
```

Get ACR password:
```bash
az acr credential show --name devopsacrshravan --query "passwords[0].value" -o tsv
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

- `backend_url`: Backend API URL (HTTPS)
- `frontend_url`: Frontend application URL (HTTPS)
- `resource_group_name`: Resource group name
- `key_vault_name`: Key Vault name

## Cleanup

```bash
terraform destroy
```

## Features

✅ **Auto-scaling**: 1-3 replicas based on load  
✅ **HTTPS**: Automatic SSL certificates  
✅ **Health checks**: Liveness and readiness probes  
✅ **Logging**: Integrated with Log Analytics  
✅ **Secrets**: Stored in Key Vault  
✅ **Cost-effective**: Pay only for what you use

## Cost Estimation

- Container Apps: ~$10-20/month (with free tier)
- Log Analytics: ~$2/month (5GB free)
- Key Vault: ~$0.03/month per secret
- **Total**: ~$12-25/month

Much cheaper than AWS due to better free tier!
