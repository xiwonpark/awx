resource "aws_instance" "ldapserver" {
  ami                    = var.cent79_ami
  vpc_security_group_ids = [var.default_sg]
  instance_type          = "t3.micro"
  subnet_id              = var.private_sn_a
  private_ip             = "10.0.30.22"
  user_data              = <<EOF
#!/bin/bash
echo 'Ezcom!234' |passwd --stdin 'root'
echo 'Ezcom!234' |passwd --stdin 'centos'
sudo hostnamectl set-hostname 'sw-tf-ldapserver'
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config
systemctl restart sshd
sudo mkdir -p /user
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport "${var.efs_dns}":/ /user
EOF

  tags = {
    Name = "sw-tf-ldapserver"
  }
}

resource "aws_instance" "vncserver" {
  ami                    = var.cent79_ami
  vpc_security_group_ids = [var.default_sg]
  instance_type          = "t3.xlarge"
  subnet_id              = var.private_sn_a
  private_ip             = "10.0.30.23"
  user_data              = <<EOF
#!/bin/bash
echo 'Ezcom!234' |passwd --stdin 'root'
echo 'Ezcom!234' |passwd --stdin 'centos'
sudo hostnamectl set-hostname 'sw-tf-vncserver'
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config
systemctl restart sshd
sudo mkdir -p /user
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport "${var.efs_dns}":/ /user

# MFA Setting
yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum -y install google-authenticator
EOF

  tags = {
    Name = "sw-tf-vncserver"
  }
}

resource "aws_alb_target_group_attachment" "target_group_attach_vnc" {
  target_group_arn = var.target_group_vnc_arn
  target_id        = aws_instance.vncserver.id
  port             = 8080
}

resource "aws_instance" "lsfserver" {
  ami                    = var.cent79_ami
  vpc_security_group_ids = [var.default_sg]
  instance_type          = "t3.micro"
  subnet_id              = var.private_sn_a
  private_ip             = "10.0.30.24"
  user_data              = <<EOF
#!/bin/bash
echo 'Ezcom!234' |passwd --stdin 'root'
echo 'Ezcom!234' |passwd --stdin 'centos'
sudo hostnamectl set-hostname 'sw-tf-lsfserver'
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config
systemctl restart sshd
sudo mkdir -p /user
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport "${var.efs_dns}":/ /user
EOF

  tags = {
    Name = "sw-tf-lsfserver"
  }
}

resource "aws_instance" "lsfnode01" {
  ami                    = var.cent79_ami
  vpc_security_group_ids = [var.default_sg]
  instance_type          = "t3.micro"
  subnet_id              = var.private_sn_a
  private_ip             = "10.0.30.25"
  user_data              = <<EOF
#!/bin/bash
echo 'Ezcom!234' |passwd --stdin 'root'
echo 'Ezcom!234' |passwd --stdin 'centos'
sudo hostnamectl set-hostname 'sw-tf-lsfnode01'
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config
systemctl restart sshd
sudo mkdir -p /user
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport "${var.efs_dns}":/ /user
EOF

  tags = {
    Name = "sw-tf-lsfnode01"
  }
}

resource "aws_instance" "test" {
  ami                    = var.cent79_ami
  vpc_security_group_ids = [var.default_sg]
  instance_type          = "t3.micro"
  subnet_id              = var.private_sn_a
  private_ip             = "10.0.30.33"
  user_data              = <<EOF
#!/bin/bash
echo 'Ezcom!234' |passwd --stdin 'root'
echo 'Ezcom!234' |passwd --stdin 'centos'
sudo hostnamectl set-hostname 'sw-tf-test'
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config
systemctl restart sshd
sudo mkdir -p /user
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport "${var.efs_dns}":/ /user
EOF

  tags = {
    Name = "sw-tf-test"
  }
}