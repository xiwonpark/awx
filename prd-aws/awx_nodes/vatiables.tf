variable "private_sn_a" {
    type = string
}

variable "default_sg" {
    type = string
}

variable "cent79_ami" {
    default = "ami-09e2a570cb404b37e"
}

variable "target_group_vnc_arn" {
    type = string
}

variable "target_group_grafana_arn" {
    type = string
}