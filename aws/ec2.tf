
data "aws_ami" "os" {
    most_recent      = true
    owners           = ["amazon"]
    filter {
      name = "name"
      values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
    }
  
}
# this conf provide you mannual key 
resource "aws_key_pair" "ngx-key" {
    key_name   = "ngx-key"
    public_key = file("/home/shubham/.ssh/id_rsa.pub")
}


resource "aws_instance" "ec2" {
    ami = data.aws_ami.os.id
    instance_type = "t2.micro"
    key_name = aws_key_pair.ngx-key.key_name
    vpc_security_group_ids = [aws_security_group.nginx-sg.id]
    subnet_id = aws_subnet.pub-sub.id
    associate_public_ip_address = true
    availability_zone = "us-west-2a"

    # user_data = <<EOF
    #             #!/bin/bash
    #             sudo apt update
    #             sudo apt install -y nginx
    #             sudo systemctl start nginx
    #             sudo systemctl enable nginx
	#      EOF

    # user_data = file("entry-script.sh")

    connection {
      type = "ssh"
      host = aws_instance.ec2.public_ip
      user = "ubuntu"
      private_key = "/home/shubham/.ssh/id_rsa"
    }

    provisioner "remote-exec" {
        inline = [ 
            "sudo apt install -y nginx",
            "sudo systemctl start nginx",
            "sudo systemctl enable nginx",
            "mkdir shubham"
         ]
      
    }

   tags = {
    Name = "nginx-web-server"
  }
}
