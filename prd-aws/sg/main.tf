resource "aws_security_group" "default_sg" {
        vpc_id = var.vpc_id
        name = "Default_sg"
        description = "Default SG"
        ingress {
                from_port = 0
                to_port = 0
                protocol = "-1"
                cidr_blocks = ["0.0.0.0/0"]
        }
        egress {
                from_port = 0
                to_port = 0
                protocol = "-1"
                cidr_blocks = ["0.0.0.0/0"]
        }
                tags = {
                        Name = "sw-tf-sg"
        }
}
