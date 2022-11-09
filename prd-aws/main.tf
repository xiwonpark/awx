provider "aws" {
        region = "ap-northeast-2"
        access_key = var.access_key
        secret_key = var.secret_key
}


module "vpc" {
        source = "./vpc"
        vpc_cidr = "10.0.0.0/16"
        public_subnet_cidr = "10.0.0.0/24"
        public2_subnet_cidr = "10.0.20.0/24"
        private_subnet_cidr = "10.0.10.0/24"
        route_cidr      = "0.0.0.0/0"
        default_sg = module.sg.default_sg
        target_id = module.ec2.ansible-controller
}

module "sg" {
        source = "./sg"
        default_sg_cidr = "0.0.0.0/0"
        vpc_id = module.vpc.vpc_id
}

module "ec2" {
        source = "./ec2"
        public_subnet = module.vpc.public_subnet
        private_subnet = module.vpc.private_subnet
        cent79_ami = "ami-09e2a570cb404b37e"
	default_sg = module.sg.default_sg
	ansible_controller_ip = "10.0.10.21"
        ansible_node01_ip = "10.0.10.22"
        ansible_node02_ip = "10.0.10.23"
}
