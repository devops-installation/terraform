provider "aws" {
    region = "us-west-2"
}

# VPC Resource
resource "aws_vpc" "RH-vpc" {
  cidr_block = var.vpc_cidr_block1

  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}
# call module subnet
module "RH-subnet" {
  source = "./modules/subnet"
  sub_cidr_block1 = var.sub_cidr_block1
  az = var.az
  env_prefix = var.env_prefix
  vpc_id = aws_vpc.RH-vpc.id
  default_route_table_id = aws_vpc.RH-vpc.default_route_table_id

}

# module "RH-subnet" {
#   source = "./modules/subnet/"  # Correct path based on your file structure
#   subnet_cidr_block = var.sub_cidr_block1
#   avail_zone        = var.az
#   env_prefix        = var.env_prefix
#   vpc_id            = aws_vpc.RH-vpc.id
#   default_route_table_id = aws_vpc.RH-vpc.default_route_table_id
# }

# # Route Table Association
# resource "aws_route_table_association" "RH_a_rta_subnate" {
#   subnet_id      = module.RH-subnet.subnet.id
#   route_table_id = aws_vpc.RH-vpc.default_route_table_id
# } 

# webserver module ec2 sg
module "webserver" {
  source = "./modules/webserver"
  env_prefix = var.env_prefix
  vpc_id = aws_vpc.RH-vpc.id
  myip = var.myip
  public_key_location = var.public_key_location
  subnet_id = module.RH-subnet.subnet.id
  az = var.az
  instance_type = var.instance_type
}


