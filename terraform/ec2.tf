module "web_ec2" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name          = "Web-Server"
  ami           = "ami-00d8fc944fb171e29"
  instance_type = "t3.micro"

  subnet_id              = aws_subnet.public_subnet.id
  private_ip             = "10.0.0.5"
  vpc_security_group_ids = [aws_security_group.web_server_sg.id]
  create_eip             = true

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  key_name             = aws_key_pair.ansible.key_name
}

module "ansible_controller" {
  source = "terraform-aws-modules/ec2-instance/aws"

  depends_on = [aws_nat_gateway.nat_gw, aws_route_table_association.private]

  name          = "Ansible-Controller"
  ami           = "ami-00d8fc944fb171e29"
  instance_type = "t3.micro"

  subnet_id                   = aws_subnet.private_subnet.id
  private_ip                  = "10.0.0.135"
  vpc_security_group_ids      = [aws_security_group.private_sg.id]
  associate_public_ip_address = false

  user_data_replace_on_change = true
  user_data                   = <<-EOF
    #!/bin/bash
    sudo apt update && sudo apt upgrade -y
    DEBIAN_FRONTEND=noninteractive sudo apt install pipx -y
    export PIPX_HOME=/opt/pipx
    export PIPX_BIN_DIR=/usr/local/bin
    sudo PIPX_HOME=/opt/pipx PIPX_BIN_DIR=/usr/local/bin pipx install --include-deps ansible
    pipx ensurepath
    sudo chmod -R 755 /opt/pipx
    echo "${file("../../ansible/ansible-key.pem")}" > /home/ssm-user/ansible-key.pem
    chmod 400 /home/ssm-user/ansible-key.pem
    chown ssm-user:ssm-user /home/ssm-user/ansible-key.pem
    mkdir -p /home/ssm-user/ansible
    git clone https://github.com/cheamirul/devops-bootcamp-project.git /home/ssm-user/ansible
    chown -R ssm-user:ssm-user /home/ssm-user/ansible
  EOF  

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  key_name             = aws_key_pair.ansible.key_name
}

module "monitoring_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name          = "Monitoring-Server"
  ami           = "ami-00d8fc944fb171e29"
  instance_type = "t3.micro"

  subnet_id                   = aws_subnet.private_subnet.id
  private_ip                  = "10.0.0.136"
  vpc_security_group_ids      = [aws_security_group.private_sg.id]
  associate_public_ip_address = false

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  key_name             = aws_key_pair.ansible.key_name
}

