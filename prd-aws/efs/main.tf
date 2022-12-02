resource "aws_efs_file_system" "efs" {
  creation_token = "sw-tf-efs"

  tags = {
    Name = "sw-tf-efs"
  }
}

resource "aws_efs_mount_target" "efs_mount_target" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = var.private_sn_a
  security_groups = [var.default_sg]
}