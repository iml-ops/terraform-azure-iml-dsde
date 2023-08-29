output "dsde_config" {
  value = {
    name                 = var.name
    location             = var.location
    network_cidr         = var.network_cidr
    boundary_cluster_id  = var.boundary_cluster_id
    azure_resource_group = azurerm_resource_group.this
  }
}
