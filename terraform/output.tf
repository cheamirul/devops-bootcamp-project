output "Web_Server_public_ip" {
  description = "Public IP of the Web Server"
  value       = module.web_ec2.public_ip  
}

output "ansible_controller_instance_id" {
  description = "Instance ID of the Ansible Controller"
  value       = module.ansible_controller.id  
}

output "ecr_repository_url" {
  description = "URL of the ECR repository for the final project"
  value       = aws_ecr_repository.final_project_repo.repository_url
}

output "ansible_ssh_key_file" {
  description = "Path to generated private ssh key for Ansible"
  value       = local_file.private_key_pem.filename
}
