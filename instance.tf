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
