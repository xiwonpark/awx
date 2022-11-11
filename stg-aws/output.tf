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

output "awx_node01" {
    value = module.awx_nodes.awx_node01
}

output "awx_node02" {
    value = module.awx_nodes.awx_node02
}

output "bastion" {
    value = module.bastion.bastion
}