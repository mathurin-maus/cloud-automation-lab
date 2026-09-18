
module "network" {
  source = "./modules/network"

  project_name        = var.project_name
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  availability_zones  = var.availability_zones
}

module "compute" {
  source = "./modules/compute"

  project_name          = var.project_name
  vpc_id                = module.network.vpc_id
  public_subnet_ids     = module.network.public_subnet_ids
  allowed_ssh_cidr      = var.allowed_ssh_cidr
  instance_type         = var.instance_type
  public_key_path       = var.public_key_path
  user_data_path        = var.user_data_path
  alb_security_group_id = module.load_balancer.alb_security_group_id
  target_group_arn      = module.load_balancer.target_group_arn
  desired_image_tag_arn = aws_ssm_parameter.desired_image_tag.arn
  rds_secret_arn        = aws_db_instance.app.master_user_secret[0].secret_arn
  rds_address           = aws_db_instance.app.address
  aws_region            = var.aws_region
  ecr_repository_url    = aws_ecr_repository.app.repository_url
  image_tag_parameter   = aws_ssm_parameter.desired_image_tag.name
}

module "load_balancer" {
  source = "./modules/load_balancer"

  project_name      = var.project_name
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
}

