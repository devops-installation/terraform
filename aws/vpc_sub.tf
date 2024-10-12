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
resource "aws_default_route_table" "default_rout_table" {
    default_route_table_id = aws_vpc.my-vpc.default_route_table_id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.ngx-igw.id
    }
    tags = {
      name  = "ngx-rout-table"
    } 
}