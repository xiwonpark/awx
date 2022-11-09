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
setenforce 0
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
#!/bin/bash
echo 'Ezcom!234' |passwd --stdin 'root'
echo 'Ezcom!234' |passwd --stdin 'centos'
sudo hostnamectl set-hostname 'ansible-controller'
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config
systemctl restart sshd
yum install -y epel-release
yum install -y ansible
sudo sed -i 's/enforcing/disabled/g' /etc/selinux/config
setenforce 0
echo """nameserver 8.8.8.8
nameserver 8.8.4.4""" >> /etc/resolv.conf
yum install -y epel-release
yum -y update
yum install -y python3
yum install -y git
yum install -y gcc gcc-c++ ansible nodejs gettext device-mapper-persistent-data lvm2 bzip2 wget nano libseccomp
wget https://download.docker.com/linux/centos/docker-ce.repo
cp docker-ec.repo /etc/yum.repos.d/
yum install -y docker-ce
systemctl enable docker
systemctl start docker
yum install -y docker-compose
alias python='/usr/bin/python3'
mkdir -p /work
touch to_do.txt
echo """git clone -b 17.1.0  https://github.com/ansible/awx.git ## for awx install
openssl rand -base64 30 ## for inventory secret-key
postgres—datadir="/var/lib/awx/pgdocker"
dockercomposedir="/var/lib/awx/awxcompose"
pg—password=Password   
pgdatabase=postgres
adminpassword=Password   
secret—key=
awxalternatedns_servers="8.8.8.8,8.8.4.4"
project—datadir=/var/lib/awx/projects""" >> to_do.txt
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