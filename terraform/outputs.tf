
#################################
# Outputs
################################

output "github_deploy_role_arn" {
  value = aws_iam_role.github_deploy.arn
}

output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}

output "rds_endpoint" {
  description = "Endpoint of the PostgreSQL RDS instance"
  value       = aws_db_instance.app.address
}

output "rds_master_secret_arn" {
  description = "ARN of the Secrets Manager secret managed by RDS"
  value       = aws_db_instance.app.master_user_secret[0].secret_arn
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.load_balancer.alb_dns_name
}