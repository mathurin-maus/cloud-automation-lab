
#################################
# Outputs
################################

output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.web.public_ip
}

output "ec2_private_ip" {
  description = "Private IP of the EC2 instance"
  value       = aws_instance.web.private_ip
}

output "ssh_command" {
  description = "SSH command to connect to the EC2 instance"
  value       = "ssh -i ~/.ssh/cloud-automation-lab ubuntu@${aws_instance.web.public_ip}"
}

