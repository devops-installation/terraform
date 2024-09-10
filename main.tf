# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
}
#resources
variable "Envirnoment" {
  description = "deployment Envirnment"
}
#we will use type = string in var in list format for multiple uses like "VPC and SUBNATE"
# variable "cidr_block" {
#   description = "cidr block for VPC and SUBNATE"
#   type = list(string)
# }

# var type = object
variable "cidr_blocks" {
  description = "cidr block for VPC and SUBNATE"
  type = list(object({
     cidr_block = string
     name = string
  }))
}

# variable "vpc_cidr_block" {
#   description = "vpc cidr block" 
#   default = "10.0.1.0/16" # this will use as default var if value not spec in var file 
# }
resource "aws_vpc" "rh-vpc" {
  # cidr_block = "10.0.0.0/16"
  # cidr_block = var.vpc_cidr_block
  cidr_block = var.cidr_blocks[0].cidr_block
  tags = {
    Name = var.cidr_blocks[0].name
    Envirnoment = var.Envirnoment
  }
}
# variable "subnate_cidr_block" {
#   description = "subnate cidr block"
#   default = "10.0.11.0/24"
# }
resource "aws_subnet" "pub-subnet" {
  vpc_id = aws_vpc.rh-vpc.id
  # cidr_block = "10.0.10.0/24"
  # cidr_block = var.subnate_cidr_block
  cidr_block = var.cidr_blocks[1].cidr_block
  availability_zone = "us-west-2a"
  tags = {
    Name = var.cidr_blocks[1].name
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
