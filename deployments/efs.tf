resource "aws_efs_file_system" "shared_storage" {
  creation_token = "wordpress-shared-storage"
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
}

resource "aws_efs_mount_target" "az_1" {
  file_system_id  = aws_efs_file_system.shared_storage.id
  subnet_id       = aws_subnet.wordpress_1.id
  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_efs_mount_target" "az_2" {
  file_system_id  = aws_efs_file_system.shared_storage.id
  subnet_id       = aws_subnet.wordpress_2.id
  security_groups = [aws_security_group.efs_sg.id]
}
