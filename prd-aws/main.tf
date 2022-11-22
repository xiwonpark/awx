provider "aws" {
        region = "ap-northeast-2"
        access_key = var.access_key
        secret_key = var.secret_key
}

module "vpc" {
        source                  = "./vpc"
        default_sg              = module.sg.default_sg
}

module "sg" {
        source                  = "./sg"
        vpc_id                  = module.vpc.vpc_id
}

module "bastion" {
        source                  = "./bastion"
        public_sn_a             = module.vpc.public_sn_a
        default_sg              = module.sg.default_sg
}

module "awx_controller" {
        source                  = "./awx_controller"
        private_sn_a            = module.vpc.private_sn_a
        default_sg              = module.sg.default_sg
        target_group_awx_arn    = module.vpc.target_group_awx_arn
}

module "awx_nodes" {
        source                  = "./awx_nodes"
        private_sn_a            = module.vpc.private_sn_a
        default_sg              = module.sg.default_sg
        target_group_vnc_arn    = module.vpc.target_group_vnc_arn
        target_group_grafana_arn = module.vpc.target_group_grafana_arn
}