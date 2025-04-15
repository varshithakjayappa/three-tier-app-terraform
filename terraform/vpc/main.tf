#aws vpc
resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

#creating internet gateway and attach it to vpc
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

#creating public subnet1 for AZ1 for web tier
resource "aws_subnet" "public-subnet1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_subnet_az1_cidr
  availability_zone = var.availability_zone_1a
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project_name}-public-subnet1"
  }
}

#creating public subnet2 for AZ2 for web tier
resource "aws_subnet" "public-subnet2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_subnet_az2_cidr
  availability_zone = var.availability_zone_1b
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project_name}-public-subnet2"
  }
}

#creating private subnet1 for AZ1 for app tier
resource "aws_subnet" "private-subnet1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_app_subnet_az1_cidr
  availability_zone = var.availability_zone_1a
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.project_name}-private-subnet1"
  }
}

#creating private subnet2 for AZ2 for app tier
resource "aws_subnet" "private-subnet2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_app_subnet_az2_cidr
  availability_zone = var.availability_zone_1b
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.project_name}-private-subnet2"
  }
}

#creating private subnet1 for AZ1 for data tier
resource "aws_subnet" "private-data-subnet1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_data_subnet_az1_cidr
  availability_zone = var.availability_zone_1a
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.project_name}-private-data-subnet1"
  }
}

#creating private subnet2 for AZ2 for data tier
resource "aws_subnet" "public-data-subnet2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_data_subnet_az2_cidr
  availability_zone = var.availability_zone_1b
  map_public_ip_on_launch = false
  tags = {
    Name = "${var.project_name}-private-data-subnet2"
  }
}

#creating Elastic Ip for NAT gateway1
resource "aws_eip" "eip_for_nat_gateway-az1" {
  domain   = "vpc"
  tags = {
    Name = "${var.project_name}-eip1"
  }
}

#creating Elastic Ip for NAT gateway2
resource "aws_eip" "eip_for_nat_gateway-az2" {
  domain   = "vpc"
  tags = {
    Name = "${var.project_name}-eip2"
  }
}

#creating NAT gateway for public subnet1 for web tier
resource "aws_nat_gateway" "nat_gatway_az1" {
  allocation_id = aws_eip.eip_for_nat_gateway-az1.id
  subnet_id     = aws_subnet.public-subnet1.id

  tags = {
    Name = "${var.project_name}-ng1"
  }
  depends_on = [aws_internet_gateway.internet_gateway]
}

#creating NAT gateway for public subnet2 for web tier
resource "aws_nat_gateway" "nat_gatway_az2" {
  allocation_id = aws_eip.eip_for_nat_gateway-az2.id
  subnet_id     = aws_subnet.public-subnet2.id

  tags = {
    Name = "${var.project_name}-ng2"
  }
  depends_on = [aws_internet_gateway.internet_gateway]
}

#creating route table and add public  route for web tier
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

#associate public subnet az1 to public route table
resource "aws_route_table_association" "public_subnet_az1_rt_association" {
  subnet_id      = aws_subnet.public-subnet1.id
  route_table_id = aws_route_table.public_route_table.id
}

#associate public subnet az2 to public route table
resource "aws_route_table_association" "public_subnet_az2_rt_association" {
  subnet_id      = aws_subnet.public-subnet2.id
  route_table_id = aws_route_table.public_route_table.id
}

#creating route table and add private route through nat gateway az1 for app tier
resource "aws_route_table" "private_route_table_az1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gatway_az1.id
  }

  tags = {
    Name = "${var.project_name}-private-rt-az1"
  }
}

#associate private subnet az1 to private route table
resource "aws_route_table_association" "private_subnet_az1_rt_association" {
  subnet_id      = aws_subnet.private-subnet1.id
  route_table_id = aws_route_table.private_route_table_az1.id
}

#creating route table and add private route through nat gateway az2 for app tier
resource "aws_route_table" "private_route_table_az2" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gatway_az2.id
  }

  tags = {
    Name = "${var.project_name}-private-rt-az2"
  }
}

#associate private subnet az2 to private route table
resource "aws_route_table_association" "private_subnet_az2_rt_association" {
  subnet_id      = aws_subnet.private-subnet2.id
  route_table_id = aws_route_table.private_route_table_az2.id
}
