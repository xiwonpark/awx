output "vpc_id" {
        value = module.vpc.vpc_id
}

output "public_subnet" {
        value = module.vpc.public_subnet
}

output "private_subnet" {
        value = module.vpc.private_subnet
}

output "vgw" {
        value = module.vpc.vgw
}

output "ansible-controller" {
        value = module.ec2.ansible-controller
}

output "ansible-node01" {
        value = module.ec2.ansible-node01
}

output "ansible-node02" {
        value = module.ec2.ansible-node02
}

output "bastion-eip" {
	value = module.ec2.bastion-eip
}

output "bastion" {
	value = module.ec2.bastion
}

# output "nginx" {
#         value = module.ec2.nginx
# }