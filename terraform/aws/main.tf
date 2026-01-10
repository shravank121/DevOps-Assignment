terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"
  
  project_name = var.project_name
  environment  = var.environment
  vpc_cidr     = var.vpc_cidr
}

# Security Groups Module
module "security" {
  source = "./modules/security"
  
  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
}

# ALB Module
module "alb" {
  source = "./modules/alb"
  
  project_name       = var.project_name
  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  alb_security_group = module.security.alb_security_group_id
}

# ECS Cluster Module
module "ecs" {
  source = "./modules/ecs"
  
  project_name            = var.project_name
  environment             = var.environment
  vpc_id                  = module.vpc.vpc_id
  private_subnet_ids      = module.vpc.private_subnet_ids
  backend_security_group  = module.security.backend_security_group_id
  frontend_security_group = module.security.frontend_security_group_id
  backend_target_group    = module.alb.backend_target_group_arn
  frontend_target_group   = module.alb.frontend_target_group_arn
  backend_image           = var.backend_image
  frontend_image          = var.frontend_image
  backend_url             = "http://${module.alb.alb_dns_name}"
}

# Secrets Manager Module
module "secrets" {
  source = "./modules/secrets"
  
  project_name = var.project_name
  environment  = var.environment
}

# Monitoring Module
module "monitoring" {
  source = "./modules/monitoring"
  
  project_name            = var.project_name
  environment             = var.environment
  aws_region              = var.aws_region
  cluster_name            = module.ecs.cluster_name
  backend_service_name    = module.ecs.backend_service_name
  frontend_service_name   = module.ecs.frontend_service_name
  alb_arn_suffix          = module.alb.alb_arn_suffix
  alert_email             = var.alert_email
}
