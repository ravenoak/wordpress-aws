resource "aws_efs_file_system" "shared_storage" {
  creation_token = "wordpress-shared-storage"
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
}

resource "aws_efs_mount_target" "shared_storage_az_1" {
  file_system_id  = aws_efs_file_system.shared_storage.id
  subnet_id       = aws_subnet.wordpress_1.id
  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_efs_mount_target" "shared_storage_az_2" {
  file_system_id  = aws_efs_file_system.shared_storage.id
  subnet_id       = aws_subnet.wordpress_2.id
  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_efs_file_system" "fastcgi_cache" {
  creation_token = "fastcgi-cache"
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
}

resource "aws_efs_mount_target" "fastcgi_cache_az_1" {
  file_system_id  = aws_efs_file_system.fastcgi_cache.id
  subnet_id       = aws_subnet.reverse_proxy_1.id
  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_efs_mount_target" "fastcgi_cache_az_2" {
  file_system_id  = aws_efs_file_system.fastcgi_cache.id
  subnet_id       = aws_subnet.reverse_proxy_2.id
  security_groups = [aws_security_group.efs_sg.id]
}
