resource "azurerm_virtual_network" "LSF_RC_vnet" {
  name                = "LSF_RC_vnet"
  location            = var.location
  resource_group_name = var.LSF_RC_RG
  address_space       = [var.vnet_cidr]
}

resource "azurerm_subnet" "LSF_RC01_sn" {
  name                 = "LSF_RC01_sn"
  resource_group_name  = var.LSF_RC_RG
  virtual_network_name = azurerm_virtual_network.LSF_RC_vnet.name
  address_prefixes     = ["10.1.0.0/24"]
}

resource "azurerm_subnet" "Gateway_sn" {
  name                 = "GatewaySubnet"
  resource_group_name  = var.LSF_RC_RG
  virtual_network_name = azurerm_virtual_network.LSF_RC_vnet.name
  address_prefixes     = ["10.1.10.0/27"]
}
resource "azurerm_local_network_gateway" "ezlgw" {
  name                = "ezlgw"
  location            = var.location
  resource_group_name = var.LSF_RC_RG
  gateway_address     = "211.226.18.70"
  address_space       = ["192.168.10.0/24"]
}

resource "azurerm_public_ip" "vgw_pip" {
  name                = "vgw_pip"
  location            = var.location
  resource_group_name = var.LSF_RC_RG
  allocation_method   = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "ezvgw" {
  name                = "ezvgw"
  location            = var.location
  resource_group_name = var.LSF_RC_RG

  type     = "Vpn"
  vpn_type = "PolicyBased"
  sku      = "Basic"

  ip_configuration {
    public_ip_address_id          = azurerm_public_ip.vgw_pip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.Gateway_sn.id
  }
}

resource "azurerm_virtual_network_gateway_connection" "LSF_RC_S2S" {
  name                = "LSF_RC_S2S"
  location            = var.location
  resource_group_name = var.LSF_RC_RG

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.ezvgw.id
  local_network_gateway_id   = azurerm_local_network_gateway.ezlgw.id

  shared_key = "Ezcom!234"
}