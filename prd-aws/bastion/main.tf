resource "aws_eip" "bastion-eip" {
	instance = aws_instance.bastion.id
	vpc = true
}

resource "aws_instance" "bastion" {
	ami = var.cent79_ami
	vpc_security_group_ids = [var.default_sg]
	instance_type ="t3.micro"
	subnet_id = var.public_sn_a
	user_data = <<EOF
#!/bin/bash
echo 'Ezcom!234' |passwd --stdin 'root'
echo 'Ezcom!234' |passwd --stdin 'centos'
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config
systemctl restart sshd
sudo sed -i 's/enforcing/disabled/g' /etc/selinux/config
init 6
EOF
	tags = {
		Name = "sw-tf-bastion"
	}
}