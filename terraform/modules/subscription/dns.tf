resource "azurerm_private_dns_zone_virtual_network_link" "dns" {
  for_each              = var.privateDnsSet
  name                  = "${var.name}-${each.key}"
  resource_group_name   = var.privateDnsRgName
  private_dns_zone_name = each.key
  virtual_network_id    = azurerm_virtual_network.envVnet.id
}
