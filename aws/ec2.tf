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
resource "aws_instance" "ec2" {
    ami = data.aws_ami.os.id
    instance_type = "t2.micro"
    key_name = "org-key"
    associate_public_ip_address = true

}