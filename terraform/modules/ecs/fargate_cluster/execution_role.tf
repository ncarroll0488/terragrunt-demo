/* This configures a execution role which can be assumed by ecs-execution. */

data "aws_iam_policy_document" "execution_trust" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "execution" {
  name               = "${var.cluster_name}_execution"
  path               = var.iam_entity_path
  assume_role_policy = data.aws_iam_policy_document.execution_trust.json

  tags = {
    Name = "Execution role for ECS cluster: ${var.cluster_name}"
  }
}

data "aws_iam_policy_document" "execution_policy" {
  statement {
    sid = "ECRAccess"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage"
    ]
    effect    = "Allow"
    resources = var.ecr_repos
  }

  statement {
    sid = "Logs"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    effect    = "Allow"
    resources = ["${aws_cloudwatch_log_group.main.arn}:log-stream:*"]
  }
}

resource "aws_iam_policy" "execution_policy" {
  name        = "${var.cluster_name}_execution"
  path        = var.iam_entity_path
  description = "Policy for ${var.cluster_name} execution role""

  policy = data.aws_iam_policy_document.execution_policy.json
}

resource "aws_iam_role_policy_attachment" "execution_policy" {
  role       = aws_iam_role.execution.name
  policy_arn = aws_iam_policy.execution_policy.arn
}
