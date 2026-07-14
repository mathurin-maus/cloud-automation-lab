
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
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.ssh.id]
  key_name                    = aws_key_pair.main.key_name
  associate_public_ip_address = true

  tags = {
    Name = "cloud-automation-lab-ec2"
  }
}


###################################
# Key Pair
###################################

resource "aws_key_pair" "main" {
  key_name   = "cloud-automation-lab"
  public_key = file(pathexpand("~/.ssh/cloud-automation-lab.pub"))

  tags = {
    Name = "cloud-automation-lab-key"
  }
}
