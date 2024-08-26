resource "aws_db_subnet_group" "wordpress" {
  name       = "wordpress"
  subnet_ids = [aws_subnet.wordpress_1.id, aws_subnet.wordpress_2.id]
}

resource "aws_rds_cluster" "wordpress" {
  cluster_identifier     = "wordpress"
  engine                 = "aurora-mysql"
  master_username        = "admin"
  master_password        = var.db_root_password
  database_name          = local.db_name
  db_subnet_group_name   = aws_db_subnet_group.wordpress.name
  vpc_security_group_ids = [aws_security_group.aurora_sg.id]
  skip_final_snapshot    = true
}

resource "aws_rds_cluster_instance" "aurora_instance_1" {
  identifier           = "aurora-instance-1"
  cluster_identifier   = aws_rds_cluster.wordpress.id
  instance_class       = "db.t2.small"
  engine               = aws_rds_cluster.wordpress.engine
  engine_version       = aws_rds_cluster.wordpress.engine_version
  publicly_accessible  = false
  db_subnet_group_name = aws_db_subnet_group.wordpress.name
  availability_zone    = "us-east-1a"
}

resource "aws_rds_cluster_instance" "aurora_instance_2" {
  identifier           = "aurora-instance-2"
  cluster_identifier   = aws_rds_cluster.wordpress.id
  instance_class       = "db.t2.small"
  engine               = aws_rds_cluster.wordpress.engine
  engine_version       = aws_rds_cluster.wordpress.engine_version
  publicly_accessible  = false
  db_subnet_group_name = aws_db_subnet_group.wordpress.name
  availability_zone    = "us-east-1b"
}
