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