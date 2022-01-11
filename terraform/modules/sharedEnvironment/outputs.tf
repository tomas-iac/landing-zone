output "vwanHubId" {
  value = azurerm_virtual_hub.vwan.id
}

output "vwanRouteId" {
  value = azurerm_virtual_hub_route_table.vwan.id
}

output "bastionVnetName" {
  value = azurerm_virtual_network.bastionVnet.name
}

output "bastionVnetId" {
  value = azurerm_virtual_network.bastionVnet.id
}

output "bastionRgName" {
  value = azurerm_resource_group.sharedRg.name
}
