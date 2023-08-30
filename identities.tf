data "azuread_client_config" "current" {}

resource "azuread_application" "app" {
  display_name = "InfiniaML DSDE"
  owners       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal" "deployer" {
  application_id               = azuread_application.app.application_id
  app_role_assignment_required = false
  owners                       = [data.azuread_client_config.current.object_id]
}

resource "azuread_service_principal_password" "deployer" {
  service_principal_id = azuread_service_principal.deployer.object_id
}

resource "azurerm_role_assignment" "rg_contributor" {
  scope                = azurerm_resource_group.this.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.deployer.object_id
}

resource "azurerm_role_assignment" "rg_rbac_admin" {
  scope                = azurerm_resource_group.this.id
  role_definition_name = "Role Based Access Control Administrator (Preview)"
  principal_id         = azuread_service_principal.deployer.object_id
}

## Sensitive Scopes
resource "azurerm_role_assignment" "sensitive_scope" {
  for_each             = { for scope in var.sensitive_scopes : scope => scope }
  scope                = azurerm_resource_group.this.id
  role_definition_name = "Role Based Access Control Administrator (Preview)"
  principal_id         = azuread_service_principal.deployer.object_id
}
