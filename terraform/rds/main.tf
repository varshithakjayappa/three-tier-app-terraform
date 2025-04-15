#creating database subnet group
resource "aws_db_subnet_group" "database_subnet_group" {
  name       = "${var.project_name}-database-subnets"
  subnet_ids = [aws_subnet.private-data-subnet1.id, aws_subnet.private-data-subnet2.id]
  description = "subnets for database instance"
  tags = {
    Name = "${var.project_name}-database-subnets"
  }
}

#creating RDS instances
resource "aws_db_instance" "database_instance" {
  db_name              = var.database_name
  engine               = var.database_engine
  engine_version       = var.database_engine_version
  instance_class       = var.database_instance_class
  username             = var.database_username
  password             = var.database_password
  parameter_group_name = var.parameter_groupname
  skip_final_snapshot  = true
  allocated_storage    = 20
  max_allocated_storage = 100
  db_subnet_group_name = aws_db_subnet_group.database_subnet_group.name
  vpc_security_group_ids = [var.database_sg_id]
  storage_encrypted = true
  backup_retention_period = 7
  
  tags = {
    name = "${var.project_name}-database_instance"
  }
}