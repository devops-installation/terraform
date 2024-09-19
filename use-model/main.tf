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
# module "RH-subnet" {
#   source = "./modules/subnet"
#   subnet_cidr_block = var.sub_cidr_block1
#   avail_zone = var.az
#   env_prefix = var.env_prefix
#   vpc_id = aws_vpc.RH-vpc.id
#   default_route_table_id = aws_vpc.RH-vpc.default_route_table_id

# }

module "RH-subnet" {
  source = "./modules/subnet"  # Correct path based on your file structure
  subnet_cidr_block = var.sub_cidr_block1
  avail_zone        = var.az
  env_prefix        = var.env_prefix
  vpc_id            = aws_vpc.RH-vpc.id
  default_route_table_id = aws_vpc.RH-vpc.default_route_table_id
}

# Route Table Association
resource "aws_route_table_association" "RH_a_rta_subnate" {
  subnet_id      = module.RH-subnet.subnet.id
  route_table_id = module.aws_default_route_table.RH_default_route_table.id
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
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
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
# ami image
data "aws_ami" "RH-FE-ubuntu" {
  most_recent = true
  owners = ["099720109477"]
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}

# key pair
resource "aws_key_pair" "ubuntu_key" {
  key_name = "ubuntu-key"
  public_key = file(var.public_key_location) # terraform server key file 
}

# EC2 instance 
resource "aws_instance" "RH-FE" {
  ami = data.aws_ami.RH-FE-ubuntu.id
  instance_type = var.instance_type
  availability_zone = var.az
  subnet_id = module.RH-subnet.subnet.id
  key_name = aws_key_pair.ubuntu_key.key_name
  vpc_security_group_ids = [aws_security_group.RH_sg.id]
  associate_public_ip_address = true

/*  
  user_data = <<EOF
                #! /bin/bash
                sudo yum update -y
                sudo yum install -y httpd.x86_64
                sudo service httpd start
                sudo service httpd enable
                echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
	    EOF
*/
  user_data = file("./vpc_subnet/entry-script.sh")
  
  tags = {
    Name = "${var.env_prefix}-RH-FE-web"
  }

}


