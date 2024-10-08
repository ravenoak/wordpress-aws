resource "aws_ecs_cluster" "main" {
  name = "main"
}

resource "aws_service_discovery_http_namespace" "interview_project" {
  name = "interview-project.local"
}

resource "aws_ecs_service" "reverse_proxy_service" {
  name            = "reverse-proxy-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.reverse_proxy.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [aws_subnet.reverse_proxy_1.id, aws_subnet.reverse_proxy_2.id]
    security_groups = [aws_security_group.reverse_proxy_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.reverse_proxy_tg.arn
    container_name   = "reverse-proxy"
    container_port   = 80
  }

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 50
}

resource "aws_ecs_service" "wordpress" {
  name            = "wordpress-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.wordpress.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = [aws_subnet.wordpress_1.id, aws_subnet.wordpress_2.id]
    security_groups = [aws_security_group.wordpress_sg.id]
  }

  service_connect_configuration {
    enabled   = true
    namespace = aws_service_discovery_http_namespace.interview_project.arn
    service {
      port_name      = "php-fpm"
      discovery_name = "wordpress"
      client_alias {
        port = 9000
      }
    }
  }

  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 50
}
