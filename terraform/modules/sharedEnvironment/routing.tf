// Virtual WAN resource group
resource "azurerm_resource_group" "vwanRg" {
  name     = "${var.prefix}-routing-rg"
  location = var.location
}

// Virtual WAN
resource "azurerm_virtual_wan" "vwan" {
  name                = "${var.prefix}-vwan"
  resource_group_name = azurerm_resource_group.vwanRg.name
  location            = azurerm_resource_group.vwanRg.location
}

resource "azurerm_virtual_hub" "vwan" {
  name                = "${var.prefix}-hub-${azurerm_resource_group.vwanRg.location}"
  resource_group_name = azurerm_resource_group.vwanRg.name
  location            = azurerm_resource_group.vwanRg.location
  virtual_wan_id      = azurerm_virtual_wan.vwan.id
  address_prefix      = "10.255.0.0/16"
  sku                 = "Standard"
}

// vWAN route - Default via Azure Firewall
resource "azurerm_virtual_hub_route_table" "vwan" {
  name           = "customRouteTable"
  virtual_hub_id = azurerm_virtual_hub.vwan.id

  route {
    name              = "all_traffic"
    destinations_type = "CIDR"
    destinations      = ["0.0.0.0/0"]
    next_hop_type     = "ResourceId"
    next_hop          = azurerm_firewall.vwan.id
  }
}
