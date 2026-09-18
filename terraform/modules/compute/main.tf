
###################################
# AMI
###################################

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}


###################################
# Launch Template
###################################

resource "aws_launch_template" "app" {
  image_id      = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.main.key_name

  user_data = base64encode(templatefile(var.user_data_path, {
    aws_region          = var.aws_region
    ecr_repository_url  = var.ecr_repository_url
    image_tag_parameter = var.image_tag_parameter
    rds_address         = var.rds_address
    rds_secret_arn      = var.rds_secret_arn
  }))

  network_interfaces {
    associate_public_ip_address = true

    security_groups = [
      aws_security_group.app.id
    ]
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_ssm.name
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name    = "${var.project_name}-app"
      Project = var.project_name
      Role    = "app"
    }
  }
}


###################################
# ASG
###################################

resource "aws_autoscaling_group" "app" {
  min_size         = var.min_size
  desired_capacity = var.desired_capacity
  max_size         = var.max_size

  vpc_zone_identifier = var.public_subnet_ids

  target_group_arns = [
    var.target_group_arn
  ]

  health_check_type         = "ELB"
  health_check_grace_period = 300

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }
}


###################################
# Key Pair
###################################

resource "aws_key_pair" "main" {
  key_name   = "${var.project_name}-key"
  public_key = file(pathexpand(var.public_key_path))

  tags = {
    Name = "${var.project_name}-key"
  }
}

###################################
# Security Group
###################################

resource "aws_security_group" "app" {
  name        = "${var.project_name}-app-sg"
  description = "Allow SSH deployment and API access"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-app-sg"
  }
}


###################################
# Security Group Ingress Rules
###################################

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.app.id

  description = "SSH from my public IP"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "api" {
  security_group_id = aws_security_group.app.id

  description                  = "API access from my public IP"
  from_port                    = 8000
  to_port                      = 8000
  ip_protocol                  = "tcp"
  referenced_security_group_id = var.alb_security_group_id
}

###################################
# Security Group Egress Rules
###################################

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.app.id

  description = "Allow all outbound traffic"
  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}
