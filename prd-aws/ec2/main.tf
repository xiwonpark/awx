resource "aws_key_pair" "keypair" {
  key_name   = "sw-tf-keypair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41"
}

resource "aws_eip" "bastion-eip" {
	instance = aws_instance.bastion.id
	vpc = true
}

# resource "aws_eip" "nginx-eip" {
# 	instance = aws_instance.nginx-proxy.id
# 	vpc = true
# }

# resource "aws_instance" "nginx-proxy" {
# 	ami = var.cent79_ami
# 	vpc_security_group_ids = [var.default_sg]
# 	instance_type ="t3.micro"
# 	subnet_id = var.public_subnet
# 	key_name = "sw-tf-keypair"
# 	user_data = <<EOF
# #!/bin/bash
# echo 'Ezcom!234' |passwd --stdin 'root'
# echo 'Ezcom!234' |passwd --stdin 'centos'
# sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
# sudo sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config
# systemctl restart sshd
# sudo sed -i 's/enforcing/disabled/g' /etc/selinux/config
# setenforce 0
# touch /etc/yum.repos.d/nginx.repo
# echo """[nginx]
# name=nginx repo
# baseurl=http://nginx.org/packages/centos/7/\$basearch/
# gpgcheck=0
# enabled=1""" > /etc/yum.repos.d/nginx.repo
# sudo yum install -y nginx
# EOF

# 	tags = {
# 		Name = "sw-tf-nginx"
# 	}
# }

resource "aws_instance" "bastion" {
	ami = var.cent79_ami
	vpc_security_group_ids = [var.default_sg]
	instance_type ="t3.micro"
	subnet_id = var.public_subnet
	key_name = "sw-tf-keypair"
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

resource "aws_instance" "ansible-controller" {
        ami = var.cent79_ami
	vpc_security_group_ids = [var.default_sg]
        instance_type = "t3.xlarge"
        subnet_id = var.private_subnet
	private_ip = var.ansible_controller_ip
	user_data = <<EOF
#!/bin/sh
#!/usr/bin/env python3

# Variables
secret_key=`openssl rand -base64 30`

# Install PKGs
yum install -y epel-release
yum update -y
yum install -y python3 git gcc gcc-c++ ansible nodejs gettext device-mapper-persistent-data lvm2 bzip2 wget nano libseccomp

# OS Setting
echo 'Ezcom!234' |passwd --stdin 'root'
echo 'Ezcom!234' |passwd --stdin 'centos'
hostnamectl set-hostname 'ansible-controller'
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config
systemctl restart sshd
sed -i 's/enforcing/disabled/g' /etc/selinux/config
echo """nameserver 8.8.8.8
nameserver 8.8.4.4""" >> /etc/resolv.conf
chattr +i /etc/resolv.conf

# Install Docker
wget https://download.docker.com/linux/centos/docker-ce.repo -P /root/
cp /root/docker-ce.repo /etc/yum.repos.d/
yum install -y docker-ce && systemctl start docker && systemctl enable docker
yum install -y docker-compose

# Install AWX
## 치환할 때 특수문자 있으면 [| + "]
git clone -b 17.1.0  https://github.com/ansible/awx.git /work
openssl rand -base64 40 >> /root/awx_secret_key.txt
sed -i 's|postgres_data_dir="~/.awx/pgdocker"|postgres_data_dir="/var/lib/awx/pgdocker"|' /work/installer/inventory
sed -i 's|docker_compose_dir="~/.awx/awxcompose"|docker_compose_dir="/var/lib/awx/awxcompose"|' /work/installer/inventory
sed -i "s|pg_password=awxpass|pg_password=Ezcom!234|" /work/installer/inventory
sed -i 's|pg_database=awx|pg_database=postgres|' /work/installer/inventory
sed -i "s|# admin_password=password|admin_password=Ezcom!234|" /work/installer/inventory
sed -i "s/secret_key=awxsecret/secret_key=$secret_key/" /work/installer/inventory
sed -i 's|#awx_alternate_dns_servers="10.1.2.3,10.2.3.4"|awx_alternate_dns_servers="8.8.8.8,8.8.4.4"|' /work/installer/inventory
sed -i 's|#project_data_dir=/var/lib/awx/projects|project_data_dir=/var/lib/awx/projects|' /work/installer/inventory

# rc.local config
echo "ansible-playbook -i /work/installer/inventory /work/installer/install.yml && sed -i /ansible/d /etc/rc.d/rc.local" && chmod -x /etc/rc.d/rc.local >> /etc/rc.d/rc.local
chmod +x /etc/rc.d/rc.local

# close script && reboot
if [ $? -eq 0 ]; then
init 6
fi
EOF

        tags = {
            Name = "sw-tf-controller"
        }
}

resource "aws_instance" "ansible-node01" {
	ami = var.cent79_ami
	vpc_security_group_ids = [var.default_sg]
	instance_type = "t3.micro"
	subnet_id = var.private_subnet
	private_ip = var.ansible_node01_ip
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

resource "aws_instance" "ansible-node02" {
	ami = var.cent79_ami
	vpc_security_group_ids = [var.default_sg]
	instance_type = "t3.micro"
	subnet_id = var.private_subnet
	private_ip = var.ansible_node02_ip
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

# resource "aws_instance" "test" {
#         ami = var.cent79_ami
# 	vpc_security_group_ids = [var.default_sg]
#         instance_type = "t3.xlarge"
#         subnet_id = var.private_subnet
# 	private_ip = "10.0.10.26"
# 	user_data = <<EOF
# #!/bin/sh
# #!/usr/bin/env python3

# # Variables
# secret_key=`openssl rand -base64 30`

# # Install PKGs
# yum install -y epel-release
# yum update -y
# yum install -y python3 git gcc gcc-c++ ansible nodejs gettext device-mapper-persistent-data lvm2 bzip2 wget nano libseccomp

# # OS Setting
# echo 'Ezcom!234' |passwd --stdin 'root'
# echo 'Ezcom!234' |passwd --stdin 'centos'
# hostnamectl set-hostname 'ansible-controller'
# sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
# sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config
# systemctl restart sshd
# sed -i 's/enforcing/disabled/g' /etc/selinux/config
# echo """nameserver 8.8.8.8
# nameserver 8.8.4.4""" >> /etc/resolv.conf
# chattr +i /etc/resolv.conf

# # Install Docker
# wget https://download.docker.com/linux/centos/docker-ce.repo -P /root/
# cp /root/docker-ce.repo /etc/yum.repos.d/
# yum install -y docker-ce && systemctl start docker && systemctl enable docker
# yum install -y docker-compose

# # Install AWX
# ## 치환할 때 특수문자 있으면 [| + "]
# git clone -b 17.1.0  https://github.com/ansible/awx.git /work
# openssl rand -base64 40 >> /root/awx_secret_key.txt
# sed -i 's|postgres_data_dir="~/.awx/pgdocker"|postgres_data_dir="/var/lib/awx/pgdocker"|' /work/installer/inventory
# sed -i 's|docker_compose_dir="~/.awx/awxcompose"|docker_compose_dir="/var/lib/awx/awxcompose"|' /work/installer/inventory
# sed -i "s|pg_password=awxpass|pg_password=Ezcom!234|" /work/installer/inventory
# sed -i 's|pg_database=awx|pg_database=postgres|' /work/installer/inventory
# sed -i "s|# admin_password=password|admin_password=Ezcom!234|" /work/installer/inventory
# sed -i "s/secret_key=awxsecret/secret_key=$secret_key/" /work/installer/inventory
# sed -i 's|#awx_alternate_dns_servers="10.1.2.3,10.2.3.4"|awx_alternate_dns_servers="8.8.8.8,8.8.4.4"|' /work/installer/inventory
# sed -i 's|#project_data_dir=/var/lib/awx/projects|project_data_dir=/var/lib/awx/projects|' /work/installer/inventory

# echo "ansible-playbook -i /work/installer/inventory /work/installer/install.yml && sed -i /ansible/d /etc/rc.d/rc.local" >> /etc/rc.d/rc.local
# chmod +x /etc/rc.d/rc.local

# if [ $? -eq 0 ]; then
# init 6
# fi
# EOF
# }