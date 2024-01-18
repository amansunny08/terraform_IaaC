# Creating Key pair (Optional, We can use existing public key)
# Create new ssh keypair using ssh-keygen
resource "aws_key_pair" "test" {
  key_name   = "test_key"
  public_key = file("${path.module}/id_rsa.pub")
}

#creating EC2 instance 
resource "aws_instance" "web" {
  ami                         = "xxxxxxxxxx"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.test.key_name
  #key_name = <existing key>
  subnet_id                   = aws_subnet.mysubnet.id
  associate_public_ip_address = "true"
  vpc_security_group_ids = ["${aws_security_group.allow_tls.id}"]
  
  tags = {
    Name = "Demo"
  }

}
