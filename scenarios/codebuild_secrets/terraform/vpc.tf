resource "aws_vpc" "vpc" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "CloudGoat ${var.cgid} VPC"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "CloudGoat ${var.cgid} Internet Gateway"
  }
}
#Public Subnets
resource "aws_subnet" "public_subnet_1" {
  availability_zone = "${var.region}a"
  cidr_block        = "10.10.10.0/24"
  vpc_id            = aws_vpc.vpc.id
  tags = {
    Name = "CloudGoat ${var.cgid} Public Subnet #1"
  }
}
resource "aws_subnet" "public_subnet_2" {
  availability_zone = "${var.region}b"
  cidr_block        = "10.10.20.0/24"
  vpc_id            = aws_vpc.vpc.id
  tags = {
    Name = "CloudGoat ${var.cgid} Public Subnet #2"
  }
}
#Private Subnets
resource "aws_subnet" "private_subnet_1" {
  availability_zone = "${var.region}a"
  cidr_block        = "10.10.30.0/24"
  vpc_id            = aws_vpc.vpc.id
  tags = {
    Name = "CloudGoat ${var.cgid} Private Subnet #1"
  }
}
resource "aws_subnet" "private_subnet_2" {
  availability_zone = "${var.region}b"
  cidr_block        = "10.10.40.0/24"
  vpc_id            = aws_vpc.vpc.id
  tags = {
    Name = "CloudGoat ${var.cgid} Private Subnet #2"
  }
}
#Public Subnet Routing Table
resource "aws_route_table" "public_subnet" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
  tags = {
    Name = "CloudGoat ${var.cgid} Route Table for Public Subnet"
  }
}
#Private Subnet Routing Table
resource "aws_route_table" "private_subnet" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "CloudGoat ${var.cgid} Route Table for Private Subnet"
  }
}

#Public Subnets Routing Associations
resource "aws_route_table_association" "public_subnet_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_subnet.id
}
resource "aws_route_table_association" "public_subnet_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_subnet.id
}

#Private Subnets Routing Associations
resource "aws_route_table_association" "priate_subnet_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_subnet.id
}
resource "aws_route_table_association" "priate_subnet_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_subnet.id
}
