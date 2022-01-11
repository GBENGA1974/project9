# CREATE A VPC

resource "aws_vpc" "PROJECT9-VPC" {
  cidr_block       = var.cidr_block[0]
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true


  tags = {
    Name = "PROJECT9-VPC"
  }
}

# PUBLIC SUBNET1

resource "aws_subnet" "project9-pubsubnet1" {
  vpc_id     = aws_vpc.PROJECT9-VPC.id
  cidr_block = var.cidr_block[1]
  map_public_ip_on_launch = true
  availability_zone = "eu-west-2a"


  tags = {
    Name = "project9-pubsubnet1"
  }
}

# PUBLIC SUBNET2

resource "aws_subnet" "project9-pubsubnet2" {
  vpc_id     = aws_vpc.PROJECT9-VPC.id
  cidr_block = var.cidr_block[2]
  map_public_ip_on_launch = true
  availability_zone = "eu-west-2b"


  tags = {
    Name = "project9-pubsubnet2"
  }
}

# PRIVATE SUBNET1

resource "aws_subnet" "project9-prisubnet1" {
  vpc_id     = aws_vpc.PROJECT9-VPC.id
  cidr_block = var.cidr_block[3]
  map_public_ip_on_launch = false
  availability_zone = "eu-west-2c"


  tags = {
    Name = "project9-prisubnet1"
  }
}

# PRIVATE SUBNET2

resource "aws_subnet" "project9-prisubnet2" {
  vpc_id     = aws_vpc.PROJECT9-VPC.id
  cidr_block = var.cidr_block[4]
  map_public_ip_on_launch = false
  availability_zone = "eu-west-2a"


  tags = {
    Name = "project9-prisubnet2"
  }
}

# CREATE PUBLIC ROUTE TABLE

resource "aws_route_table" "project9-PUBLIC-RT" {
  vpc_id = aws_vpc.PROJECT9-VPC.id

  tags = {
    Name = "project9-PUBLIC-RT"
  }
}

# CREATE PRIVATE ROUTE TABLE

resource "aws_route_table" "project9-PRIVATE-RT" {
  vpc_id = aws_vpc.PROJECT9-VPC.id

  tags = {
    Name = "project9-PRIVATE-RT"
  }
}

# INTERNET GATEWAY

resource "aws_internet_gateway" "PROJECT9-igw" {
  vpc_id = aws_vpc.PROJECT9-VPC.id

  tags = {
    Name = "PROJECT9-igw"
  }
}


# IGW ASSOCIATION WITH ROUTE TABLE

resource "aws_route" "Assoc-public-RT" {
  route_table_id            = aws_route_table.project9-PUBLIC-RT.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.PROJECT9-igw.id
}

# ASSOCIATE PUBLIC SUBNET1 TO PUBLIC ROUTE

resource "aws_route_table_association" "project9-PUBSUB1-ASSOC-PUB-RT" {
  subnet_id      = aws_subnet.project9-pubsubnet1.id
  route_table_id = aws_route_table.project9-PUBLIC-RT.id
}

# ASSOCIATE PUBLIC SUBNET2 TO PUBLIC ROUTE

resource "aws_route_table_association" "project9-PUBSUB2-ASSOC-PUB-RT" {
  subnet_id      = aws_subnet.project9-pubsubnet2.id
  route_table_id = aws_route_table.project9-PUBLIC-RT.id
}

# ASSOCIATE PRIVATE SUBNET1 TO PRIVATE ROUTE

resource "aws_route_table_association" "project9-PRIVSUB1-ASSOC-PRIV-RT" {
  subnet_id      = aws_subnet.project9-prisubnet1.id
  route_table_id = aws_route_table.project9-PRIVATE-RT.id
}

# ASSOCIATE PRIVATE SUBNET2 TO PRIVATE ROUTE

resource "aws_route_table_association" "project9-PRIVSUB2-ASSOC-PRIV-RT" {
  subnet_id      = aws_subnet.project9-prisubnet2.id
  route_table_id = aws_route_table.project9-PRIVATE-RT.id
}

# SECURITY GROUP FOR VPC
# terraform aws create security GROUP

resource "aws_security_group" "PROJECT9-vpc-security-group" {
  name        = "project9-vpc-security-group"
  description = "Allow ssh and HTTP access or port 80 and 22 and outbound traffic to PROJECT9-VPC"
  vpc_id      = aws_vpc.PROJECT9-VPC.id


  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP Access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "project9-vpc-security-group"
  }
}
