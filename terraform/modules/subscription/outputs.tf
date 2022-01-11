output "envVnetId" {
  value = azurerm_virtual_network.envVnet.id
}

output "envRgName" {
  value = azurerm_resource_group.envRg.name
}
