resource "azurerm_network_interface" "sw-tf-nic001" {
  name                = "sw-tf-nic001"
  location            = var.location
  resource_group_name = var.LSF_RC_RG

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.LSF_RC01_sn
    private_ip_address_allocation = "static"
    private_ip_address            = "var.sw-tf-vm001"
  }
}

resource "azurerm_linux_virtual_machine" "sw-tf-vm001" {
  name                = "sw-tf-vm001"
  resource_group_name = var.LSF_RC_RG
  location            = var.location
  size                = "StandardB2s"
  admin_username      = "ezadmin"
  admin_password      = "Ezcom!@#$1234"

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  network_interface_ids = [azurerm_network_interface.sw-tf-nic001.id]

  source_image_id = "/subscriptions/676452ad-1286-44f1-a7ea-a7dcef5f8c8c/resourceGroups/hybird-rg/providers/Microsoft.Compute/images/4cycleimage-sw-image-20220926103343"
}