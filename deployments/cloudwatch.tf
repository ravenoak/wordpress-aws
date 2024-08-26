resource "aws_cloudwatch_log_group" "interview_project" {
  name              = "/ecs/main/interview-project"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_stream" "wordpress" {
  name           = "wordpress"
  log_group_name = aws_cloudwatch_log_group.interview_project.name
}

resource "aws_cloudwatch_log_stream" "reverse_proxy" {
  name           = "reverse-proxy"
  log_group_name = aws_cloudwatch_log_group.interview_project.name
}
