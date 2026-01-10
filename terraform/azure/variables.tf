variable "azure_region" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "devops"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

variable "vnet_cidr" {
  description = "VNet CIDR block"
  type        = string
  default     = "10.1.0.0/16"
}

variable "backend_image" {
  description = "Backend Docker image"
  type        = string
}

variable "frontend_image" {
  description = "Frontend Docker image"
  type        = string
}

variable "acr_login_server" {
  description = "Azure Container Registry login server"
  type        = string
  default     = "devopsacrshravan.azurecr.io"
}

variable "acr_username" {
  description = "Azure Container Registry username"
  type        = string
}

variable "acr_password" {
  description = "Azure Container Registry password"
  type        = string
  sensitive   = true
}

variable "alert_email" {
  description = "Email address for alerts"
  type        = string
  default     = "your-email@example.com"
}
