# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
}
#resources
variable "Envirnoment" {
  description = "deployment Envirnment"
}

variable "vpc_cidr_block" {
  description = "vpc cidr block" 
  default = "10.0.1.0/16" # this will use as default var if value not spec in var file 
}
resource "aws_vpc" "rh-vpc" {
  # cidr_block = "10.0.0.0/16"
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "RH-VPC"
    Envirnoment = var.Envirnoment
  }
}
variable "subnate_cidr_block" {
  description = "subnate cidr block"
  default = "10.0.11.0/24"
}
resource "aws_subnet" "pub-subnet" {
  vpc_id = aws_vpc.rh-vpc.id
  # cidr_block = "10.0.10.0/24"
  cidr_block = var.subnate_cidr_block
  availability_zone = "us-west-2a"
  tags = {
    Name = "RH-PUB-subnet"
    Envirnoment = var.Envirnoment
  }
}
#data :- use to fetch existing resources info
data "aws_vpc" "default-vpc" {
  default = true
}

resource "aws_subnet" "pub-subnet-default-1" {
  vpc_id = data.aws_vpc.default-vpc.id
  cidr_block = "172.31.64.0/20"
  # cidr_block = var.subnate_cidr_block
  availability_zone = "us-west-2b"
  tags = {
    Name = "pub-subnet-default-1"
    Envirnoment = var.Envirnoment
  }
}
output "default-vpc-id" {
  value = aws_vpc.rh-vpc.id
}
output "pub-sub-id-1" {
  value = aws_subnet.pub-subnet-default-1.id 
}
