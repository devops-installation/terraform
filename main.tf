# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
}

# # Create an EC2 instance
# resource "aws_instance" "example" {
#   ami           = "ami-0c94855ba95c71c99"  # Replace with a valid AMI ID for your region
#   instance_type = "t2.micro"               # Change as per your requirements

#   tags = {
#     Name = "MyEC2Instance"
#   }
# }
