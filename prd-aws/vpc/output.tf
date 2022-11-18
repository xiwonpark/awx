output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_sn_a" {
  value = aws_subnet.public_sn_a.id
}

output "public_sn_b" {
  value = aws_subnet.public_sn_b.id
}

output "private_sn_a" {
  value = aws_subnet.private_sn_a.id
}

output "target_group_awx_arn" {
  value = aws_alb_target_group.target_group_awx.arn
}

output "target_group_vnc_arn" {
  value = aws_alb_target_group.target_group_vnc.arn
}