#Add New Route table
resource "aws_route_table" "myroute" {
  vpc_id = aws_vpc.myvpc.id
  route  = []
  tags = {
    Name = "example"
  }
}