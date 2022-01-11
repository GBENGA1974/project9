# VARIABLES

variable "region" {
    type = string
    default = "eu-west-2"
}

variable "cidr_block" {
    type = list(string)
    default = ["10.0.0.0/16","10.0.51.0/24","10.0.52.0/24","10.0.53.0/24","10.0.54.0/24"]
}

variable "ami" {
    type = string
    default = "ami-0d37e07bd4ff37148"
}

variable "image_id" {
    type = string
    default = "ami-029ed17b4ea379178" 
}

variable "instance_type" {
    type = string
    default = "t2.micro"
}
