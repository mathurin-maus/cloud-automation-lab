
variable "project_name" {
  type = string
}


variable "aws_region" {
  type = string
}


variable "vpc_cidr" {
  type = string
}


variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability Zones used by the public subnets"
  type        = list(string)
}


variable "instance_type" {
  type = string
}


variable "allowed_ssh_cidr" {
  type = string
}

variable "public_key_path" {
  description = "Path to the SSH public key"
  type        = string
}

variable "user_data_path" {
  description = "Path to the EC2 user data script"
  type        = string
}


