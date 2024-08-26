resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "public_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "reverse_proxy_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "wordpress_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "public_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.128.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_subnet" "reverse_proxy_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.129.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_subnet" "wordpress_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.130.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_eip" "nat_1" {
  domain = "vpc"
}

resource "aws_eip" "nat_2" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat_1" {
  allocation_id = aws_eip.nat_1.id
  subnet_id     = aws_subnet.public_1.id
}

resource "aws_nat_gateway" "nat_2" {
  allocation_id = aws_eip.nat_2.id
  subnet_id     = aws_subnet.public_2.id
}

resource "aws_route_table" "igw" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table" "private_1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1.id
  }
}

resource "aws_route_table" "private_2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_2.id
  }
}

resource "aws_route_table_association" "public_1_igw" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.igw.id
}

resource "aws_route_table_association" "public_2_igw" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.igw.id
}

resource "aws_route_table_association" "reverse_proxy_private_1" {
  subnet_id      = aws_subnet.reverse_proxy_1.id
  route_table_id = aws_route_table.private_1.id
}

resource "aws_route_table_association" "wordpress_private_1" {
  subnet_id      = aws_subnet.wordpress_1.id
  route_table_id = aws_route_table.private_1.id
}

resource "aws_route_table_association" "reverse_proxy_private_2" {
  subnet_id      = aws_subnet.reverse_proxy_2.id
  route_table_id = aws_route_table.private_2.id
}

resource "aws_route_table_association" "wordpress_private_2" {
  subnet_id      = aws_subnet.wordpress_2.id
  route_table_id = aws_route_table.private_2.id
}
