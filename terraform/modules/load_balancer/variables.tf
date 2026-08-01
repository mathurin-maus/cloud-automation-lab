
variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "IDs of the public subnets used by the ALB"
  type        = list(string)
}

variable "application_port" {
  description = "Port exposed by the application targets"
  type        = number
  default     = 8000
}