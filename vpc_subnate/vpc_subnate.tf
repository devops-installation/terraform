provider "aws" {
    region = "us-west-2"
}
#variable
variable "vpc_cidr_block1" {}
variable "sub_cidr_block1" {}
variable "env_prefix" {}
variable "az" {}
# VPC Resource
resource "aws_vpc" "RH-vpc" {
  cidr_block = var.vpc_cidr_block1

  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

# Subnet Resource
resource "aws_subnet" "RH_subnate-1" {
  vpc_id            = aws_vpc.RH-vpc.id
  cidr_block        = var.sub_cidr_block1
  availability_zone = var.az

  tags = {
    Name = "${var.env_prefix}-subnate-1"
  }
}

# Internet Gateway Resource
resource "aws_internet_gateway" "RH_igw" {
  vpc_id = aws_vpc.RH-vpc.id

  tags = {
    Name = "${var.env_prefix}-igw"
  }
}

# # route table
# resource "aws_route_table" "RH_rout_table" {
#   vpc_id = aws_vpc.RH-vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.RH_igw.id
#       }
#   tags = {
#     Name = "${var.env_prefix}-rout_table"
#   }
# }
# # rout table association
# resource "aws_route_table_association" "RH_a_rta_subnate" {
#   subnet_id = aws_subnet.RH_subnate-1.id
#   route_table_id = aws_route_table.RH_rout_table.id
# }

# Default Route Table: Modify default route table for the VPC
resource "aws_default_route_table" "RH_default_route_table" {
  default_route_table_id = aws_vpc.RH-vpc.default_route_table_id  # Use the default route table of the VPC

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.RH_igw.id
  }

  tags = {
    Name = "${var.env_prefix}-default-route-table"
  }
}

# Route Table Association
resource "aws_route_table_association" "RH_a_rta_subnate" {
  subnet_id      = aws_subnet.RH_subnate-1.id
  route_table_id = aws_default_route_table.RH_default_route_table.id
}
