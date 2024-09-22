# security group
resource "aws_security_group" "RH_sg" {
  name        = "${var.env_prefix}-sg"
  description = "Allow inbound traffic on port 22 and 80"
  vpc_id      = var.vpc_id

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
  owners = ["amazon"]
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
  subnet_id = var.subnet_id
  key_name = aws_key_pair.ubuntu_key.key_name
  vpc_security_group_ids = [aws_security_group.RH_sg.id]
  associate_public_ip_address = true

 
  # user_data = <<EOF
  #               #!/bin/bash
  #               sudo apt update
  #               sudo apt install -y nginx
  #               sudo systemctl start nginx
  #               sudo systemctl enable nginx
	#           EOF

  user_data = file("entry-script.sh")
  
  tags = {
    Name = "${var.env_prefix}-RH-FE-web"
  }
}   