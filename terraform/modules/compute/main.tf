
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
# EC2
###################################

resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [aws_security_group.ssh.id]
  key_name                    = aws_key_pair.main.key_name
  associate_public_ip_address = true

  user_data                   = file(var.user_data_path)
  user_data_replace_on_change = true

  tags = {
    Name = "${var.project_name}-ec2"
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

resource "aws_security_group" "ssh" {
  name        = "${var.project_name}-ssh"
  description = "Allow SSH deployment and API access"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-ssh"
  }
}


###################################
# Security Group Ingress Rules
###################################

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.ssh.id

  description = "SSH from my public IP"
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"
  cidr_ipv4   = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "api" {
  security_group_id = aws_security_group.ssh.id

  description = "API access from my public IP"
  from_port   = 8000
  to_port     = 8000
  ip_protocol = "tcp"
  cidr_ipv4   = var.allowed_ssh_cidr
}

###################################
# Security Group Egress Rules
###################################

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.ssh.id

  description = "Allow all outbound traffic"
  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}
