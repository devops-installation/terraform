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
  enable_nat_gateway = true
  enable_vpn_gateway = true

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