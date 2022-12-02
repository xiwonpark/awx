output "efs_dns" {
  value = aws_efs_file_system.efs.dns_name
}