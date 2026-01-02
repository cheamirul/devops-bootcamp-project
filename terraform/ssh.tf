resource "aws_key_pair" "ansible" {
  key_name   = "ansible-key"
  public_key = file("../ansible/ansible-key.pub")
}
