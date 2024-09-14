provider "aws" {
    region = "us-west-2"
}
#variable
variable "vpc_cidr_block1" {}
variable "sub_cidr_block1" {}
variable "env_prefix" {}
variable "az" {}
variable "myip" {}
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
# security group
resource "aws_security_group" "RH_sg" {
  name        = "${var.env_prefix}-sg"
  description = "Allow inbound traffic on port 22 and 80"
  vpc_id      = aws_vpc.RH-vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "http"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0 # any port 0
    to_port = 0
    protocol = "-1" # any protocol
    cidr_blocks = [var.myip]
    prefix_list_ids = []
  }
  tags = {
    Name = "${var.env_prefix}-sg-1"
  }
}