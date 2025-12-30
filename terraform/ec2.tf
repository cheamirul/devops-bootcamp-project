module "web_ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "Web-Server"
  ami           = "ami-00d8fc944fb171e29"
  instance_type = "t3.micro"

  subnet_id     = aws_subnet.public_subnet.id
  private_ip = "10.0.0.5"
  vpc_security_group_ids = [aws_security_group.web_server_sg.id]
  create_eip = true
  
  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  key_name = aws_key_pair.ansible.key_name
}

module "ansible_controller" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "Ansible-Controller"
  ami           = "ami-00d8fc944fb171e29"
  instance_type = "t3.micro"

  subnet_id     = aws_subnet.private_subnet.id
  private_ip    = "10.0.0.135"
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  associate_public_ip_address = false

  user_data_replace_on_change = true
  user_data = <<-EOF
    #!/bin/bash
    sudo apt update && sudo apt upgrade -y
    sudo apt install pipx -y
    sudo PIPX_HOME=/opt/pipx PIPX_BIN_DIR=/usr/local/bin pipx --include-deps install ansible
    pipx ensurepath
  EOF  

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  key_name = aws_key_pair.ansible.key_name
}

module "monitoring_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  name = "Monitoring-Server"
  ami           = "ami-00d8fc944fb171e29"
  instance_type = "t3.micro"

  subnet_id     = aws_subnet.private_subnet.id
  private_ip    = "10.0.0.136"
  vpc_security_group_ids = [aws_security_group.private_sg.id]
  associate_public_ip_address = false

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  key_name = aws_key_pair.ansible.key_name
}

