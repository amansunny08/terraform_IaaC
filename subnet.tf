#Aad Subnet subnet
resource "aws_subnet" "mysubnet" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  
  tags = {
    Name = "subnet1"
  }
}