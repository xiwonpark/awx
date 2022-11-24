module "vnet" {
  source    = "./vnet"
  vnet_cidr = "10.1.0.0/16"
  location  = "Korea Central"
  LSF_RC_RG = "LSF_RC_RG"
}

module "vm" {
  source      = "./vm"
  location    = "Korea Central"
  LSF_RC_RG   = "LSF_RC_RG"
  sw-tf-vm001 = "10.1.0.21"
  LSF_RC01_sn = module.vnet.LSF_RC01_sn
}