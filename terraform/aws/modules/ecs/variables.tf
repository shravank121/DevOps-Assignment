variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs"
  type        = list(string)
}

variable "backend_security_group" {
  description = "Backend security group ID"
  type        = string
}

variable "frontend_security_group" {
  description = "Frontend security group ID"
  type        = string
}

variable "backend_target_group" {
  description = "Backend target group ARN"
  type        = string
}

variable "frontend_target_group" {
  description = "Frontend target group ARN"
  type        = string
}

variable "backend_image" {
  description = "Backend Docker image"
  type        = string
}

variable "frontend_image" {
  description = "Frontend Docker image"
  type        = string
}

variable "backend_url" {
  description = "Backend URL for frontend"
  type        = string
}
