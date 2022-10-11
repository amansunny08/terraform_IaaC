# aws provider
provider "aws" {
  region     = "ap-south-1"
  access_key = "xxxxx"
  secret_key = "xxxxx"
}

#VPC
resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
}

#subnet
resource "aws_subnet" "mysubnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  tags = {
    Name = "subnet1"
  }
}

#Internet GW
resource "aws_internet_gateway" "mygw" {
  vpc_id = aws_vpc.myvpc.id
  tags = {
    Name = "gw"
  }
}

#Route table
resource "aws_route_table" "myroute" {
  vpc_id = aws_vpc.myvpc.id
  route  = []
  tags = {
    Name = "example"
  }
}

# Route
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

#Security Group
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


# Creating Key pair
resource "aws_key_pair" "test" {
  key_name   = "test_key"
  public_key = file("${path.module}/id_rsa.pub")
}

#creating EC2 instance 

resource "aws_instance" "web" {
  ami                         = "ami-01216e7612243e0ef"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.test.key_name
  subnet_id                   = aws_subnet.mysubnet.id
  associate_public_ip_address = "true"
  vpc_security_group_ids = ["${aws_security_group.allow_tls.id}"]
  tags = {
    Name = "aman"
  }

}

output publicip {
    value = aws_instance.web.public_ip
}

output state {
    value = aws_instance.web.instance_state
}

output primaryinterface {
    value = aws_instance.web.primary_network_interface_id
}