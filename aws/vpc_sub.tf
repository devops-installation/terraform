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