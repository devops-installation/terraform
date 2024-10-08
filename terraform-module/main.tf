terraform {
  # Configure the AWS Provider
  required_version = ">= 0.12"
  backend "s3" {
    bucket = "rh-tf-state-bucket" 
    key = "terraform/state.tfstate"
    region = "us-west-2" 
  }
}

provider "aws" {
    region = "us-west-2"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "RH-vpc"
  cidr = var.vpc_cidr_block1

  azs             = [var.az]
#   private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = [var.sub_cidr_block1]
  public_subnet_tags = { 
    Name = "${var.env_prefix}-pub-sub-1"
    }
 # diasable service that we didnt want in module
   enable_nat_gateway = false
   enable_vpn_gateway = false

  tags = {
   Name = "${var.env_prefix}-vpc"
  }
}

module "webserver" {
  source = "./webserver"
  env_prefix = var.env_prefix
  vpc_id = module.vpc.vpc_id
  myip = var.myip
  public_key_location = var.public_key_location
  subnet_id = module.vpc.public_subnets[0]
  az = var.az
  instance_type = var.instance_type
}