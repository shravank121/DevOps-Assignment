# CI/CD Pipeline Setup Guide

## Overview

This project uses GitHub Actions for CI/CD with deployment to:
- **AWS** (ECS Fargate)
- **GCP** (Cloud Run)

## Pipeline Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    Push to develop                          │
└─────────────────────┬───────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────┐
│                    CI Pipeline                              │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │Backend Tests│  │Frontend Test│  │ Build & Push Images │  │
│  │   (pytest)  │  │   (lint)    │  │   (ECR + GCR)       │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                      │
                      ▼ (merge to main)
┌─────────────────────────────────────────────────────────────┐
│                  Deploy Pipeline                            │
│  ┌─────────────────────┐  ┌─────────────────────────────┐   │
│  │   Deploy to AWS     │  │     Deploy to GCP           │   │
│  │   (ECS Fargate)     │  │     (Cloud Run)             │   │
│  └─────────────────────┘  └─────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

## Required GitHub Secrets

Go to: Repository → Settings → Secrets and variables → Actions

### AWS Secrets

| Secret Name | Description | How to Get |
|-------------|-------------|------------|
| `AWS_ACCESS_KEY_ID` | IAM user access key | AWS Console → IAM → Users → Security credentials |
| `AWS_SECRET_ACCESS_KEY` | IAM user secret key | Created with access key |
| `AWS_BACKEND_URL` | Backend ALB URL | After Terraform apply (e.g., `http://alb-xxx.us-east-1.elb.amazonaws.com`) |

### GCP Secrets

| Secret Name | Description | How to Get |
|-------------|-------------|------------|
| `GCP_SA_KEY` | Service account JSON key | GCP Console → IAM → Service Accounts → Keys → Add Key → JSON |
| `GCP_PROJECT_ID` | GCP project ID | GCP Console → Project selector (e.g., `my-project-123`) |
| `GCP_BACKEND_URL` | Backend Cloud Run URL | After deployment (e.g., `https://devops-backend-xxx.run.app`) |

## AWS IAM Policy (Minimum Required)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ecs:UpdateService",
        "ecs:DescribeServices"
      ],
      "Resource": "*"
    }
  ]
}
```

## GCP Service Account Roles

- `roles/artifactregistry.writer` - Push images
- `roles/run.admin` - Deploy to Cloud Run
- `roles/iam.serviceAccountUser` - Use service account

## Image Tagging Strategy

Images are tagged with:
- `<git-sha>` - Unique identifier for each commit
- `latest` - Most recent build

Example:
```
123456789.dkr.ecr.us-east-1.amazonaws.com/devops-backend:abc123def
123456789.dkr.ecr.us-east-1.amazonaws.com/devops-backend:latest
```

## Triggering Deployments

| Action | Trigger |
|--------|---------|
| Run tests + build images | Push to `develop` |
| Deploy to AWS + GCP | Push/merge to `main` |

## Monitoring Pipeline Runs

1. Go to repository → Actions tab
2. Click on workflow run to see details
3. Check job logs for any failures

## Troubleshooting

### ECR Login Failed
- Verify `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` are correct
- Check IAM user has ECR permissions

### GCP Auth Failed
- Ensure `GCP_SA_KEY` contains valid JSON
- Verify service account has required roles

### ECS Update Failed
- Confirm cluster and service names match Terraform output
- Check ECS service exists and is running
