variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

variable "public_sn_a" {
    default = "10.0.10.0/24"
}

variable "public_sn_b" {
    default = "10.0.20.0/24"
}

variable "private_sn_a" {
    default = "10.0.30.0/24"
}

variable "route_cidr" {
    default = "0.0.0.0/0"
}

variable "default_sg" {
    type = string
}