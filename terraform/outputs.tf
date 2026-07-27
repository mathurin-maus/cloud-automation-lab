
#################################
# Outputs
################################

output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = module.compute.ec2_public_ip
}

output "ec2_private_ip" {
  description = "Private IP of the EC2 instance"
  value       = module.compute.ec2_private_ip
}

