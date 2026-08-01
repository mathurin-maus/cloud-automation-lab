
variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_id" {
  type = string
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
