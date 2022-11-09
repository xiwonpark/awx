output "ansible-controller" {
        value = aws_instance.ansible-controller.id
}

output "ansible-node01" {
        value = aws_instance.ansible-node01.id
}

output "ansible-node02" {
        value = aws_instance.ansible-node02.id
}

output "bastion-eip" {
	value = aws_eip.bastion-eip.id
}

output "bastion" {
	value = aws_instance.bastion.id
}

# output "nginx" {
#         value = aws_instance.nginx-proxy.id
# }