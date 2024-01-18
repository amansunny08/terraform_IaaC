# Terraform Provide
# https://registry.terraform.io/providers/hashicorp/aws/latest

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.32.1"
    }
  }
}

# aws Provider
provider "aws" {
  region     = "xxxxxxx"
  access_key = "xxxxxxx"
  secret_key = "xxxxxxx"
}

# Create new VPC
resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "myvpc-1"
  }
}

#Add New Subnet
resource "aws_subnet" "mysubnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "xxxxxx"

  tags = {
    Name = "subnet1"
  }
}

#Add New Internet Gateways
resource "aws_internet_gateway" "mygw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "gw"
  }
}

#Create new Route Table
resource "aws_route_table" "myroute" {
  vpc_id = aws_vpc.myvpc.id
  route = []

  tags = {
    Name = "example"
  }
}

# Update Route Table
resource "aws_route" "route" {
  route_table_id         = aws_route_table.myroute.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.mygw.id
  depends_on             = [aws_route_table.myroute]
}

#Route Association
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.mysubnet.id
  route_table_id = aws_route_table.myroute.id
}

#Add New Security Group
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.myvpc.id

  dynamic "ingress" {
    for_each = [22, 80, 443]
    iterator = port
    content {
      description = "TLS from VPC"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}


# New new Key pair  (Optional, we can use existing key) 
resource "aws_key_pair" "test" {
  key_name   = "test_key"
  public_key = file("${path.module}/id_rsa.pub")
}

#Creating EC2 instance 
resource "aws_instance" "web" {
  ami                         = "xxxxxxxxxxxxxx"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.test.key_name
  # key_name = existing key name  
  subnet_id                   = aws_subnet.mysubnet.id
  associate_public_ip_address = "true"
  vpc_security_group_ids = ["${aws_security_group.allow_tls.id}"]
  tags = {
    Name = "demo"
  }

}


### For output (Optional)
output "vpc_id" {
  value = aws_vpc.myvpc.id
}

output "subnet_id" {
  value = aws_subnet.mysubnet.id
}

output "igw_id" {
  value = aws_internet_gateway.mygw.id
}

output "route-table" {
  value = aws_route_table.myroute.id
}

output "public_ip" {
  value = aws_instance.web.public_ip
}

output "private_ip" {
  value = aws_instance.web.private_ip
}