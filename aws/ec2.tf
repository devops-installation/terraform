

resource "aws_vpc" "my-vpc" {
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "my-vpc"
    }  
}
resource "aws_internet_gateway" "ngx-igw" {
    vpc_id = aws_vpc.my-vpc.id
    tags = {
      Name = "ngx-igw"
    }
  
}
resource "aws_subnet" "pub-sub" {
    cidr_block = "10.0.1.0/24"
    vpc_id = aws_vpc.my-vpc.id
    availability_zone = "us-west-2a"
  
}

data "aws_ami" "os" {
    most_recent      = true
    owners           = ["amazon"]
    filter {
      name = "name"
      values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
    }
  
}
# # this conf provide you mannual key 
# resource "aws_key_pair" "org-key" {
#     key_name   = "org-key"
#     public_key = 
# }
resource "aws_security_group" "nginx-sg" {
    name = "nginx-sg"
    description = "nginx sg "
    vpc_id = aws_vpc.my-vpc.id
    ingress {
        from_port = 22
        to_port   = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
  
}
resource "aws_ebs_volume" "ec2_vol" {
    size = 10
    availability_zone = aws_instance.ec2.availability_zone 
}
resource "aws_instance" "ec2" {
    ami = data.aws_ami.os.id
    instance_type = "t2.micro"
    key_name = "org-key"
    vpc_security_group_ids = [aws_vpc.my-vpc.id]
    subnet_id = aws_subnet.pub-sub.id
    associate_public_ip_address = true
    availability_zone = "us-west-2a"
    user_data = <<EOF
                #!/bin/bash
                #sudo apt update
                sudo apt install -y nginx
                sudo systemctl start nginx
                sudo systemctl enable nginx
	    EOF

    tags = {
      Name = "ec2"
    }
}
resource "aws_volume_attachment" "ebs-disk1" {
    device_name = "/dev/sdh"
    volume_id = aws_ebs_volume.ec2_vol.id
    instance_id = aws_instance.ec2.id
 
}
