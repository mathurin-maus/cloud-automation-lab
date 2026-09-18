
variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "allowed_ssh_cidr" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "public_key_path" {
  type = string
}

variable "user_data_path" {
  type = string
}

variable "alb_security_group_id" {
  description = "ID of the ALB Security Group allowed to reach the application"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the target group used by the Auto Scaling Group"
  type        = string
}

variable "min_size" {
  type    = number
  default = 0
}

variable "desired_capacity" {
  type    = number
  default = 0
}

variable "max_size" {
  type    = number
  default = 4
}

variable "desired_image_tag_arn" {
  description = "ARN of the SSM parameter storing the desired application image tag"
  type        = string
}

variable "rds_secret_arn" {
  description = "ARN of the Secrets Manager secret managed by RDS"
  type        = string
}

variable "rds_address" {
  description = "DNS address of the PostgreSQL RDS instance"
  type        = string
}

variable "aws_region" {
  type = string
}

variable "ecr_repository_url" {
  type = string
}

variable "image_tag_parameter" {
  type = string
}
