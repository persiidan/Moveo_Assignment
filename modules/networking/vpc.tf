resource "aws_vpc" "moveo" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = false 

  tags = {
    Name = "nginx-VPC"
  }
}
resource "aws_subnet" "private_az1" {
  vpc_id     = aws_vpc.moveo.id
  availability_zone = "il-central-1a"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = false
  tags = {
    Name = "Private Subnet in az 1a"
  }
}
# 2 public subnets for alb and high availability
resource "aws_subnet" "public_nat_subnet" {
  vpc_id     = aws_vpc.moveo.id
  availability_zone = "il-central-1a"
  cidr_block = "10.0.3.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet for NAT"
  }
}

resource "aws_subnet" "public_alb_subnet" {
  vpc_id     = aws_vpc.moveo.id
  availability_zone = "il-central-1b"
  cidr_block = "10.0.4.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "Public Subnet for ALB"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.moveo.id
  tags = {
    Name = "igw"
  }
}

resource "aws_eip" "elastic_ip_nat" {
  domain = "vpc"
  tags = {
    Name = "nat-eip"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  depends_on = [aws_internet_gateway.igw]
  subnet_id     = aws_subnet.public_nat_subnet.id
  allocation_id = aws_eip.elastic_ip_nat.id
  tags = {
    Name = "NAT_gw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.moveo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public-rt"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.moveo.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
    tags = {
    Name = "private-rt"
  }
}
resource "aws_route_table_association" "private_az1" {
  subnet_id      = aws_subnet.private_az1.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "public_natc" {
  subnet_id      = aws_subnet.public_nat_subnet.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public_alb" {
  subnet_id      = aws_subnet.public_alb_subnet.id
  route_table_id = aws_route_table.public.id
}

