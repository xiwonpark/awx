output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet" {
  value = aws_subnet.public.id
}

output "private_subnet" {
  value = aws_subnet.private.id
}

output "vgw" {
    value = aws_vpn_gateway.vpn_gw.id
}
