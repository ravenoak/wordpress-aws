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
}
