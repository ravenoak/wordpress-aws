resource "aws_launch_template" "jump_host" {
  name          = "jump_host"
  image_id      = "ami-066784287e358dad1"
  instance_type = "t2.micro"
  key_name      = "jump_host"
  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.ssh_access.id]
    subnet_id                   = aws_subnet.public_1.id
  }
}

resource "aws_key_pair" "jump_host" {
  key_name   = "jump_host"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKXRMaRw9hs2cf75Meg8/AjEVKw57zoIC5FB4zgUStzd"
}
