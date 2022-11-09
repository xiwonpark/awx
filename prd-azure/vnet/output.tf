output "vnet_cidr" {
    value = azurerm_virtual_network.LSF_RC_vnet.address_space
}

output "LSF_RC01_sn" {
    value = azurerm_subnet.LSF_RC01_sn.id
}