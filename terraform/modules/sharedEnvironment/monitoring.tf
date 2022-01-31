// Log workspace
resource "azurerm_log_analytics_workspace" "logs" {
  name                = "${var.prefix}-logs345345672"
  location            = azurerm_resource_group.sharedRg.location
  resource_group_name = azurerm_resource_group.sharedRg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

// Azure Monitor for Containers
resource "azurerm_log_analytics_solution" "containers" {
  solution_name         = "ContainerInsights"
  location              = azurerm_resource_group.sharedRg.location
  resource_group_name   = azurerm_resource_group.sharedRg.name
  workspace_resource_id = azurerm_log_analytics_workspace.logs.id
  workspace_name        = azurerm_log_analytics_workspace.logs.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}
