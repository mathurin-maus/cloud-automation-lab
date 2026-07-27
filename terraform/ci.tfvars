
project_name = "cloud-automation-lab"

aws_region = "eu-west-3"

vpc_cidr           = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"
availability_zone  = "eu-west-3a"

instance_type = "t3.micro"

allowed_ssh_cidr = "82.66.55.29/32"

public_key_path = "keys/cloud-automation-lab.pub"
user_data_path  = "scripts/install-docker.sh"
