resource "aws_instance" "awx_node01" {
	ami = var.cent79_ami
	vpc_security_group_ids = [var.default_sg]
	instance_type = "t3.micro"
	subnet_id = var.private_sn_a
	private_ip = "10.0.30.22"
	user_data = <<EOF
#!/bin/bash
echo 'Ezcom!234' |passwd --stdin 'root'
echo 'Ezcom!234' |passwd --stdin 'centos'
sudo hostnamectl set-hostname 'ansible-node01'
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config
systemctl restart sshd
EOF

	tags = {
		Name = "sw-tf-node01"
	}
}

resource "aws_instance" "awx_node02" {
	ami = var.cent79_ami
	vpc_security_group_ids = [var.default_sg]
	instance_type = "t3.micro"
	subnet_id = var.private_sn_a
	private_ip = "10.0.30.23"
	user_data = <<EOF
#!/bin/bash
echo 'Ezcom!234' |passwd --stdin 'root'
echo 'Ezcom!234' |passwd --stdin 'centos'
sudo hostnamectl set-hostname 'ansible-node02'
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config
systemctl restart sshd
EOF

	tags = {
		Name = "sw-tf-node02"
	}
}