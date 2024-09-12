provider "aws" {
    region = "us-west-2"
}
#variable
variable "vpc_cidr_block1" {}
variable "sub_cidr_block1" {}
variable "env_prefix" {}
variable "az" {}
#vpc
resource "aws_vpc" "RH-vpc" {
    cidr_block = var.vpc_cidr_block1
    tags = {
      Name = "${var.env_prefix}-vpc"
    }
}
#subnate
resource "aws_subnet" "RH_subnate-1" {
    vpc_id = aws_vpc.RH-vpc.id
    cidr_block = var.sub_cidr_block1
    availability_zone = var.az
    tags = {
      Name = "${var.env_prefix}-subnate-1"
    }
}

