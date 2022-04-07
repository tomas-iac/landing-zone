// Bastion VNET
resource "azurerm_virtual_network" "bastionVnet" {
  name                = "${var.prefix}-bastion-vnet"
  location            = azurerm_resource_group.sharedRg.location
  resource_group_name = azurerm_resource_group.sharedRg.name
  address_space       = ["10.243.0.0/16"]

  subnet {
    name           = "AzureBastionSubnet"
    address_prefix = "10.243.0.0/24"
  }
}

// Bastion Public IP
resource "azurerm_public_ip" "bastion" {
  name                = "bastion-ip"
  location            = azurerm_resource_group.sharedRg.location
  resource_group_name = azurerm_resource_group.sharedRg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

// Azure Bastion
resource "azurerm_bastion_host" "bastion" {
  name                = "bastion"
  location            = azurerm_resource_group.sharedRg.location
  resource_group_name = azurerm_resource_group.sharedRg.name
  sku                 = "Standard"
  ip_configuration {
    name                 = "configuration"
    subnet_id            = "${azurerm_virtual_network.bastionVnet.id}/subnets/AzureBastionSubnet"
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}




