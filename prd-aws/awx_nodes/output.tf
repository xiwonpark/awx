output "ldapserver" {
  value = aws_instance.ldapserver.id
}

output "vncserver" {
  value = aws_instance.vncserver.id
}

output "lsfserver" {
  value = aws_instance.lsfserver.id
}

output "lsfnode01" {
  value = aws_instance.lsfnode01.id
}