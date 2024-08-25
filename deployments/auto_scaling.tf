resource "aws_appautoscaling_target" "reverse_proxy_scaling_target" {
  max_capacity       = 10
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.main.id}/${aws_ecs_service.reverse_proxy_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "reverse_proxy_scale_up" {
  name               = "reverse-proxy-scale-up"
  resource_id        = aws_appautoscaling_target.reverse_proxy_scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.reverse_proxy_scaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.reverse_proxy_scaling_target.service_namespace
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = 50.0
  }
}

resource "aws_appautoscaling_policy" "reverse_proxy_scale_down" {
  name               = "reverse-proxy-scale-down"
  resource_id        = aws_appautoscaling_target.reverse_proxy_scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.reverse_proxy_scaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.reverse_proxy_scaling_target.service_namespace
  policy_type        = "StepScaling"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    metric_aggregation_type = "Average"

    step_adjustment {
      scaling_adjustment          = -1
      metric_interval_lower_bound = 0
    }
  }
}

resource "aws_appautoscaling_target" "wordpress_scaling_target" {
  max_capacity       = 10
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.main.id}/${aws_ecs_service.wordpress.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "wordpress_scale_up" {
  name               = "wordpress-scale-up"
  resource_id        = aws_appautoscaling_target.wordpress_scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.wordpress_scaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.wordpress_scaling_target.service_namespace
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value = 75.0
  }
}

resource "aws_appautoscaling_policy" "wordpress_scale_down" {
  name               = "wordpress-scale-down"
  resource_id        = aws_appautoscaling_target.wordpress_scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.wordpress_scaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.wordpress_scaling_target.service_namespace
  policy_type        = "StepScaling"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    metric_aggregation_type = "Average"

    step_adjustment {
      scaling_adjustment          = -1
      metric_interval_lower_bound = 0
    }
  }
}
