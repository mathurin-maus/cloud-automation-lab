
###################################
# Security Group
###################################

resource "aws_security_group" "ssh" {
  name        = "cloud-automation-lab-ssh"
  description = "Allow SSH from my public IP"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "cloud-automation-lab-ssh"
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
  cidr_ipv4   = var.allowed_ssh_cidr
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
