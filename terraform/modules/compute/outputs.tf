
output "app_security_group_id" {
  description = "ID of the application EC2 Security Group"
  value       = aws_security_group.app.id
}