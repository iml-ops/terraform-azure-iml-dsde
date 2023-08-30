output "dsde_config" {
  sensitive = true
  value = {
    name                 = var.name
    location             = var.location
    network_cidr         = var.network_cidr
    boundary_cluster_id  = var.boundary_cluster_id
    azure_resource_group = azurerm_resource_group.this
    authorized_scopes    = var.sensitive_scopes
    sp_config = base64encode(jsonencode({
      client_id     = azuread_service_principal.deployer.application_id
      client_secret = azuread_service_principal_password.deployer.value
      tenant_id     = data.azuread_client_config.current.tenant_id
    }))
  }
}
