// Linux jump server
resource "azurerm_network_interface" "jump" {
  name                = "jump-nic"
  location            = azurerm_resource_group.sharedRg.location
  resource_group_name = azurerm_resource_group.sharedRg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "${azurerm_virtual_network.sharedVnet.id}/subnets/subnet1"
    private_ip_address_allocation = "Dynamic"
  }
}

locals {
  custom_data = <<CUSTOM_DATA
#!/bin/bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv ./kubectl /usr/bin
wget https://github.com/derailed/k9s/releases/download/v0.25.18/k9s_Linux_x86_64.tar.gz
tar xvf k9s_Linux_x86_64.tar.gz
sudo mv k9s /usr/bin/
  CUSTOM_DATA
}

resource "azurerm_linux_virtual_machine" "jump" {
  name                            = "jump-vm"
  resource_group_name             = azurerm_resource_group.sharedRg.name
  location                        = azurerm_resource_group.sharedRg.location
  size                            = "Standard_B1ms"
  admin_username                  = "labuser"
  admin_password                  = "Azure12345678"
  disable_password_authentication = false
  custom_data                     = base64encode(local.custom_data)

  network_interface_ids = [
    azurerm_network_interface.jump.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}
