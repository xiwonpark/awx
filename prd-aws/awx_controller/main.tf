resource "aws_instance" "awx_controller" {
        ami = var.cent79_ami
	vpc_security_group_ids = [var.default_sg]
        instance_type = "t3.xlarge"
        subnet_id = var.private_sn_a
	private_ip = var.awx_controller_ip
	user_data = <<EOF
#!/bin/sh
#!/usr/bin/env python3

# Variables
secret_key=`openssl rand -base64 30`
pkglist="python3 git gcc gcc-c++ ansible nodejs gettext device-mapper-persistent-data lvm2 bzip2 wget nano libseccomp docker"

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

# Install PKGs
while :
do
        ping -c 4 8.8.8.8 > /dev/null
        if [ $? -eq 0 ]; then
        echo "ping test success"
        break
        fi
done

yum install -y epel-release && yum update -y

for i in $pkglist
do
        checkpkg=`rpm -q $i`
        if [ "$checkpkg" == "package $i is not installed" ]; then
                yum install -y $i
        fi
done

if [ $? -eq 0 ]; then
        echo "success"
else
        echo "fail"
fi

# Install Docker
wget https://download.docker.com/linux/centos/docker-ce.repo -P /root/

if [ $? -eq 0 ]; then
cp /root/docker-ce.repo /etc/yum.repos.d/
fi

if [ $? -eq 0 ]; then
        yum install -y docker-ce
        yum install -y docker-compose
fi

systemctl enable docker && systemctl start docker

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
echo "ansible-playbook -i /work/installer/inventory /work/installer/install.yml && sed -i /ansible/d /etc/rc.d/rc.local && chmod -x /etc/rc.d/rc.local" >> /etc/rc.d/rc.local

if [ $? -eq 0 ]; then
        chmod +x /etc/rc.d/rc.local
fi

# close script && reboot
if [ $? -eq 0 ]; then
init 6
fi
EOF

        tags = {
            Name = "sw-tf-controller"
        }
}

resource "aws_alb_target_group_attachment" "target_group_attach" {
        target_group_arn = var.target_group_awx_arn
        target_id = aws_instance.awx_controller.id
        port = 80
}