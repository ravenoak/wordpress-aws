##
# Wordpress Task
##

resource "aws_ecs_task_definition" "wordpress" {
  family                   = "wordpress"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  volume {
    name = "shared-storage"
    efs_volume_configuration {
      file_system_id     = aws_efs_file_system.shared_storage.id
      transit_encryption = "ENABLED"
    }
  }

  container_definitions = jsonencode([
    {
      name      = "wordpress"
      image     = local.wordpress_image
      essential = true
      mountPoints = [
        {
          sourceVolume  = "shared-storage"
          containerPath = "/var/www/html"
        }
      ]
      environment = [
        {
          name  = "WORDPRESS_DB_HOST"
          value = aws_rds_cluster.wordpress.endpoint
        },
        {
          name  = "WORDPRESS_DB_USER"
          value = local.db_user
        },
        {
          name  = "WORDPRESS_DB_PASSWORD"
          value = var.wordpress_db_password
        },
        {
          name  = "WORDPRESS_DB_NAME"
          value = local.db_name
        }
      ]
      portMappings = [
        {
          containerPort = 9000
          hostPort      = 9000
          name          = "php-fpm"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.interview_project.name
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = aws_cloudwatch_log_stream.wordpress.name
        }
      }
    }
  ])
}

##
# NGINX Task
##
resource "aws_ecs_task_definition" "reverse_proxy" {
  family                   = "reverse-proxy"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  volume {
    name = "shared-storage"
    efs_volume_configuration {
      file_system_id     = aws_efs_file_system.shared_storage.id
      transit_encryption = "ENABLED"
    }
  }

  container_definitions = jsonencode([
    {
      name      = "reverse-proxy"
      image     = local.reverse_proxy_image
      essential = true
      mountPoints = [
        {
          sourceVolume  = "shared-storage"
          containerPath = "/var/www/html"
        }
      ]
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          name          = "http"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.interview_project.name
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = aws_cloudwatch_log_stream.reverse_proxy.name
        }
      }
    }
  ])
}
