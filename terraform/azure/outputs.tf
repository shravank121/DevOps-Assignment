output "resource_group_name" {
  description = "Resource group name"
  value       = azurerm_resource_group.main.name
}

output "backend_url" {
  description = "Backend URL"
  value       = "https://${azurerm_container_app.backend.ingress[0].fqdn}"
}

output "frontend_url" {
  description = "Frontend URL"
  value       = "https://${azurerm_container_app.frontend.ingress[0].fqdn}"
}

output "container_app_environment" {
  description = "Container Apps environment name"
  value       = azurerm_container_app_environment.main.name
}

output "key_vault_name" {
  description = "Key Vault name"
  value       = azurerm_key_vault.main.name
}

output "log_analytics_workspace" {
  description = "Log Analytics workspace name"
  value       = azurerm_log_analytics_workspace.main.name
}
