data "aws_vpc" "default" {
    default = true  
}
data "aws_eip" "freedebt_eip" {
    filter {
        name = "tag:Name"
        values = ["freedebt"]
    }
}
resource "aws_eip_association" "attach_freedebt_eip" {
    instance_id = aws_instance.freedebt-app.id
    allocation_id = data.aws_eip.freedebt_eip.id
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

  #  user_data = file("entry-script.sh")
    connection {
        type = "ssh"
        host = aws_instance.freedebt-app.public_ip
        user = "ubuntu"
        private_key = file(var.private_key_location)
    }
    provisioner "remote-exec" {
        # script = file("entry-script.sh")
        inline = [
            "sudo apt install -y nginx",
            "sudo systemctl start nginx",
            "sudo systemctl enable nginx",
            "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash",
            
            # Step 3: Add NVM to shell profile (~/.bashrc)
            "echo 'export NVM_DIR=\"$HOME/.nvm\"' >> ~/.bashrc",
            "echo '[ -s \"$NVM_DIR/nvm.sh\" ] && \\. \"$NVM_DIR/nvm.sh\" # This loads nvm' >> ~/.bashrc",
            
            # Step 4: Reload the shell profile to apply changes
            "source ~/.bashrc",
            
            # Step 5: Install latest version of Node.js using NVM
            "nvm install node",
            
            # Step 6: Set latest Node.js version as default
            "nvm alias default node",
            "mkdir shubham"
         ]
      
    }
    tags = {
        Name = "${var.name}-webserver"
    }

}