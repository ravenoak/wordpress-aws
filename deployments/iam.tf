data "aws_iam_policy_document" "ecs_task_execution_role_trust" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ecs_task_execution_role_permissions" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role_trust.json
  name               = "ecs-task-execution-role"

  inline_policy {
    name   = "ecs-task-execution-role-policy"
    policy = data.aws_iam_policy_document.ecs_task_execution_role_permissions.json
  }
}
