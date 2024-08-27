locals {
  reverse_proxy_image = "ravenoak/wp-nginx-fcgi:latest"
  wordpress_image     = "wordpress:6.6-php8.3-fpm-alpine"
  db_user             = "wordpress"
  db_name             = "wordpress"
}

variable "db_root_password" {
  description = "The root password for the database"
  type        = string
  sensitive   = true
}

variable "wordpress_db_password" {
  description = "The password for the WordPress database user"
  type        = string
  sensitive   = true
}

variable "aws_account" {
  description = "The AWS account ID"
  type        = string
  default     = "816069151329"
}

variable "allow_ssh_ip" {
  description = "An IP address to allow SSH access from the outside"
  type        = string
}
