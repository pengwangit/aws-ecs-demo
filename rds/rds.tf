resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "main"
  subnet_ids = [var.private_subnet_a_rds_id, var.private_subnet_b_rds_id]

  tags = {
    Name = format("%s_rds_subnet_group", var.project_name)
  }
}

resource "aws_db_instance" "rds" {
  allocated_storage       = var.allocated_storage
  max_allocated_storage   = var.max_allocated_storage
  storage_type            = "gp2"
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  backup_retention_period = var.backup_retention_period
  multi_az                = var.multi_az
  name                    = var.database_name
  username                = var.database_username
  password                = var.database_password
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.id
  vpc_security_group_ids  = [var.rds_sg_id]
  skip_final_snapshot     = true # for demo purpose
  tags = {
    Name = format("%s_rds", var.project_name)
  }
}
