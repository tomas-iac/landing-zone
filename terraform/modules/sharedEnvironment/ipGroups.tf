// IP groups representing shared environment
resource "azurerm_ip_group" "shared" {
  name                = "sharedenv-ipgroup"
  location            = azurerm_resource_group.vwanRg.location
  resource_group_name = azurerm_resource_group.vwanRg.name
  cidrs               = azurerm_virtual_network.sharedVnet.address_space
}

// IP groups representing each environment
resource "azurerm_ip_group" "vwan" {
  for_each            = fileset(path.module, "subscriptions/*.yaml")
  name                = "${yamldecode(file(each.value)).name}-ipgroup"
  location            = azurerm_resource_group.vwanRg.location
  resource_group_name = azurerm_resource_group.vwanRg.name
  cidrs               = [yamldecode(file(each.value)).vnetRange]
}
