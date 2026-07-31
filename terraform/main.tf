
module "network" {
  source = "./modules/network"

  project_name        = var.project_name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  availability_zones  = var.availability_zones
}

module "compute" {
  source = "./modules/compute"

  project_name     = var.project_name
  vpc_id           = module.network.vpc_id
  public_subnet_id = module.network.public_subnet_ids[0]
  allowed_ssh_cidr = var.allowed_ssh_cidr
  instance_type    = var.instance_type
  public_key_path  = var.public_key_path
  user_data_path   = var.user_data_path
}