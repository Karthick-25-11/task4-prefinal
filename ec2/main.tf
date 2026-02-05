resource "aws_instance" "this" {
  ami                    = "ami-0532be01f26a3de55"
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.sg_id]
  key_name               = var.key_name
  user_data              = file("${path.module}/userdata.sh")

  tags = {
    Name = "strapi-private-ec2"
  }
}