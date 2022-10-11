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