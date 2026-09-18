
resource "aws_db_subnet_group" "app" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = module.network.public_subnet_ids
}


resource "aws_security_group" "rds" {
  name = "${var.project_name}-rds-sg"

  description = "Allow database Postgree access"
  vpc_id      = module.network.vpc_id

  tags = {
    Name = "${var.project_name}-rds-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "db" {
  security_group_id = aws_security_group.rds.id

  description                  = "PostgreSQL access from application EC2 instances"
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  referenced_security_group_id = module.compute.app_security_group_id
}


resource "aws_db_instance" "app" {
  identifier = "${var.project_name}-db"

  engine         = "postgres"
  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = "appdb"
  username = "appadmin"

  manage_master_user_password = true

  port = 5432

  db_subnet_group_name = aws_db_subnet_group.app.name

  vpc_security_group_ids = [
    aws_security_group.rds.id
  ]

  publicly_accessible = false
  multi_az            = false

  skip_final_snapshot = true
}