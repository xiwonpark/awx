variable "private_sn_a" {
        type = string
}

variable "default_sg" {
        type = string
}

variable "target_group_arn" {
        type = string
}

variable "cent79_ami" {
        default = "ami-09e2a570cb404b37e"
}

variable "awx_controller_ip" {
        default = "10.0.30.21"
}