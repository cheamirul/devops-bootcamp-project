output "public_ip" {
  description = "Public IP of the Web Server"
  value       = module.web_ec2.public_ip  
}

output "ansible_controller_instance_id" {
  description = "Instance ID of the Ansible Controller"
  value       = module.ansible_controller.id  
}

output "ansible_ssh_key_file" {
  description = "Path to generated private ssh key for Ansible"
  value       = local_file.private_key_pem.filename
}
