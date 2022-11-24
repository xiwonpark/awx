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
EOF

  tags = {
    Name = "sw-tf-ldapserver"
  }
}

resource "aws_instance" "vncserver" {
  ami                    = var.cent79_ami
  vpc_security_group_ids = [var.default_sg]
  instance_type          = "t3.micro"
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
EOF

  tags = {
    Name = "sw-tf-lsfnode01"
  }
}

resource "aws_instance" "grafana" {
  ami                    = var.cent79_ami
  vpc_security_group_ids = [var.default_sg]
  instance_type          = "t3.large"
  subnet_id              = var.private_sn_a
  private_ip             = "10.0.30.26"
  user_data              = <<EOF
#!/bin/bash
echo 'Ezcom!234' |passwd --stdin 'root'
echo 'Ezcom!234' |passwd --stdin 'centos'
sudo hostnamectl set-hostname 'sw-tf-grafana'
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo sed -i 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config
systemctl restart sshd
EOF

  tags = {
    Name = "sw-tf-grafana"
  }
}

resource "aws_alb_target_group_attachment" "target_group_attach_grafana" {
  target_group_arn = var.target_group_grafana_arn
  target_id        = aws_instance.grafana.id
  port             = 3000
}