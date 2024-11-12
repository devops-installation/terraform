data "aws_vpc" "default" {
    default = true  
}

data "aws_ami" "ubuntu-os" {
    most_recent = true
    owners = ["amazon"]
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
    }
}
resource "aws_security_group" "freedebt-sg" {
    name = "${var.name}-sg"
    description = "allow port to MERN stack"
    vpc_id = data.aws_vpc.default.id

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
        from_port = 5000
        to_port = 5000
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
        from_port = 0 
        to_port = 0
        protocol =  "-1"
        cidr_blocks = ["0.0.0.0/0"]
        prefix_list_ids = []
    }


    tags = {
        Name = "${var.name}-sg"
    }
  
}
resource "aws_key_pair" "freedebt-key" {
    key_name = "${var.name}-key"
    public_key = file(var.public_key_location)
}
resource "aws_instance" "freedebt-app" {
    ami = data.aws_ami.ubuntu-os.id
    instance_type = "t2.micro"
    key_name = aws_key_pair.freedebt-key.key_name
    vpc_security_group_ids = [aws_security_group.freedebt-sg.id]
    associate_public_ip_address = true

    user_data = file("entry-script.sh")

    tags = {
        Name = "${var.name}-webserver"
    }

}