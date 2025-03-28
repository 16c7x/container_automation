resource "aws_instance" "bastion" {
  ami                    = "ami-030f8f64679a7bef6"
  instance_type          = "t2.large"
  count                  = "1"
  key_name               = "andrew.jones"
  subnet_id              = aws_subnet.fortress_subnet[0].id
  vpc_security_group_ids = aws_security_group.fortress_sg[*].id
  #security_groups = [aws_security_group.fortress_sg.id]

tags = {
    Name     = "Fortress Bastion Host"
    lifetime = "7d"
    email    = "andrew.jones@perforce.com"
  }
}