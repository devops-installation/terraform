# Subnet Resource
resource "aws_subnet" "RH_subnate-1" {
  vpc_id            = var.vpc_id
  cidr_block        = var.sub_cidr_block1
  availability_zone = var.az

  tags = {
    Name = "${var.env_prefix}-subnate-1"
  }
}

# Internet Gateway Resource
resource "aws_internet_gateway" "RH_igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env_prefix}-igw"
  }
}
# Default Route Table: Modify default route table for the VPC
resource "aws_default_route_table" "RH_default_route_table" {
  default_route_table_id = var.default_route_table_id  # Use the default route table of the VPC

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.RH_igw.id
  }

  tags = {
    Name = "${var.env_prefix}-default-route-table"  
  }
}
