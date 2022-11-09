resource "aws_vpc" "vpc" {
        cidr_block = var.vpc_cidr
        tags = {
                Name = "sw-tf-vpc"
        }
}

resource "aws_subnet" "public" {
        vpc_id = aws_vpc.vpc.id
        availability_zone = "ap-northeast-2a"
        cidr_block = var.public_subnet_cidr

        tags = {
                Name = "sw-tf-pb-sn"
        }
}

resource "aws_subnet" "public2" {
        vpc_id = aws_vpc.vpc.id
        availability_zone = "ap-northeast-2c"
        cidr_block = var.public2_subnet_cidr

        tags = {
                Name = "sw-tf-pb2-sn"
        }
}

resource "aws_subnet" "private" {
        vpc_id = aws_vpc.vpc.id
        availability_zone = "ap-northeast-2a"
        cidr_block = var.private_subnet_cidr

        tags = {
                Name = "sw-tf-pv-sn"
        }
}

resource "aws_internet_gateway" "igw" {
        vpc_id = aws_vpc.vpc.id
        tags = {
                 Name = "sw-tf-igw"
        }
}

resource "aws_default_route_table" "public_route_table" {
        default_route_table_id = aws_vpc.vpc.default_route_table_id
        route {
                cidr_block = var.route_cidr
                gateway_id = aws_internet_gateway.igw.id
        }
	tags = {
		Name = "sw-tf-pb-rt"
		}
}

resource "aws_route_table" "private_route_table" {
        vpc_id = aws_vpc.vpc.id
        route {
                cidr_block = var.route_cidr
                gateway_id = aws_nat_gateway.nat_gateway.id
        }
        tags = {
                Name = "sw-tf-pv-rt"
        }
}

resource "aws_route_table_association" "public_2a" {
        subnet_id = aws_subnet.public.id
        route_table_id = aws_default_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_2a" {
        subnet_id = aws_subnet.private.id
        route_table_id = aws_route_table.private_route_table.id
}

resource "aws_eip" "nat_eip" {
	vpc = true
	lifecycle {
	create_before_destroy = true
	}
}

resource "aws_nat_gateway" "nat_gateway" {
	allocation_id = aws_eip.nat_eip.id
	subnet_id = aws_subnet.public.id

	tags = {
		Name = "sw-tf-nat-gw"
	}
}

resource "aws_vpn_gateway" "vpn_gw" {
        vpc_id = aws_vpc.vpc.id

        tags = {
                Name = "sw-tf-vgw"
        }
}

resource "aws_alb" "alb" {
        name = "sw-tf-alb"
        internal = false
        load_balancer_type = "application"
        security_groups = [var.default_sg]
        subnets = [aws_subnet.public.id, aws_subnet.public2.id]

        tags = {
                Name = "sw-tf-alb"
        }
}

resource "aws_alb_target_group" "target_group" {
        name = "sw-tf-tg-awx"
        port = 80
        protocol = "HTTP"
        vpc_id = aws_vpc.vpc.id
}

resource "aws_alb_target_group_attachment" "target_group_attach" {
        target_group_arn = aws_alb_target_group.target_group.arn
        target_id = var.target_id
        port = 80
}

data "aws_acm_certificate" "aws_cert" {
        domain = "ez-test.link"
        statuses = ["ISSUED"]
}

resource "aws_alb_listener" "listener" {
        load_balancer_arn = aws_alb.alb.arn
        port = "443"
        protocol = "HTTPS"
        ssl_policy = "ELBSecurityPolicy-2016-08"
        certificate_arn = data.aws_acm_certificate.aws_cert.arn

        default_action {
                target_group_arn = aws_alb_target_group.target_group.arn
                type = "forward"
        }
}