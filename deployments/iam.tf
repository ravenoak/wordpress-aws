data "aws_iam_policy_document" "ecs_task_execution_role_trust" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"
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

data "aws_iam_role" "aws_service_role_ecs" {
  name = "AWSServiceRoleForECS"
}

data "aws_iam_policy_document" "gha_ecr_push_trust" {
  statement {
    principals {
      identifiers = ["arn:aws:iam::816069151329:oidc-provider/token.actions.githubusercontent.com"]
      type = "Federated"
    }
    actions = ["sts:AssumeRoleWithWebIdentity"]
    condition {
      test     = "StringEquals"
      values = ["sts.amazonaws.com"]
      variable = "token.actions.githubusercontent.com:aud"
    }
    condition {
      test     = "StringLike"
      values = ["repo:ravenoak/wordpress-aws:*"]
      variable = "token.actions.githubusercontent.com:sub"
    }
  }
}

data "aws_iam_policy_document" "gha_ecr_push_permissions" {
  statement {
    actions = [
      "ecr:CompleteLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:InitiateLayerUpload",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage"
    ]
    resources = ["arn:aws:ecr:us-east-1:${var.aws_account}:repository/services/wordpress"]
  }
  statement {
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role" "gha_ecr_push_role" {
  assume_role_policy = data.aws_iam_policy_document.gha_ecr_push_trust.json
  name               = "gha-ecr-push-role-oidc"
  inline_policy {
    name   = "gha-ecr-push-policy"
    policy = data.aws_iam_policy_document.gha_ecr_push_permissions.json
  }
}
