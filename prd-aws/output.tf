output "public_sn_a" {
  value = module.vpc.private_sn_a
}

output "public_sn_b" {
  value = module.vpc.public_sn_b
}

output "private_sn_a" {
  value = module.vpc.private_sn_a
}

output "default_sg" {
  value = module.sg.default_sg
}

output "awx_controller" {
  value = module.awx_controller.awx_controller
}

output "ldapserver" {
  value = module.awx_nodes.ldapserver
}

output "vncserver" {
  value = module.awx_nodes.vncserver
}

output "lsfserver" {
  value = module.awx_nodes.lsfserver
}

output "lsfnode01" {
  value = module.awx_nodes.lsfnode01
}

output "bastion" {
  value = module.bastion.bastion
}