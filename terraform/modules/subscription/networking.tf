// Environment resource group
resource "azurerm_resource_group" "envRg" {
  name     = "${var.prefix}-${var.name}-rg"
  location = var.location
  tags     = var.tags
}


// Environment VNET
resource "azurerm_virtual_network" "envVnet" {
  name                = "${var.prefix}-${var.name}-vnet"
  location            = azurerm_resource_group.envRg.location
  resource_group_name = azurerm_resource_group.envRg.name
  address_space       = [var.vnetRange]
  tags                = var.tags
}

// VWAN connection
resource "azurerm_virtual_hub_connection" "envVnet" {
  name                      = "${var.prefix}-${var.name}-connection"
  virtual_hub_id            = var.vwanHubId
  remote_virtual_network_id = azurerm_virtual_network.envVnet.id
  internet_security_enabled = true

  routing {
    associated_route_table_id = var.vwanRouteId
  }
}

// Peering to and from Bastion
resource "azurerm_virtual_network_peering" "env-bastion" {
  name                      = "${var.name}-bastion"
  resource_group_name       = azurerm_resource_group.envRg.name
  virtual_network_name      = azurerm_virtual_network.envVnet.name
  remote_virtual_network_id = var.bastionVnetId
}

resource "azurerm_virtual_network_peering" "bastion-env" {
  name                      = "bastion-${var.name}"
  resource_group_name       = var.bastionRgName
  virtual_network_name      = var.bastionVnetName
  remote_virtual_network_id = azurerm_virtual_network.envVnet.id
}
