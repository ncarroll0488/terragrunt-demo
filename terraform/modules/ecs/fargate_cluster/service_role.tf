/* This configures a service role which can be assumed by EventBridge or ECS. */

data "aws_iam_policy_document" "service_trust" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com", "events.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "service" {
  name               = "${var.cluster_name}_service"
  path               = var.iam_entity_path
  assume_role_policy = data.aws_iam_policy_document.service_trust.json

  tags = {
    Name = "Service role for ECS cluster: ${var.cluster_name}"
  }
}

data "aws_iam_policy_document" "service_policy" {
  statement {
    sid = "RunTask"
    actions = [
      "ecs:RunTask"
    ]
    effect    = "Allow"
    resources = var.task_definition_arns

    // Restrict these actions to our cluster
    condition {
      test     = "ArnEquals"
      variable = "ecs:cluster"

      values = [
        aws_ecs_cluster.main.arn
      ]
    }
  }

  // Allow the passing of our task and execution roles
  statement {
    sid = "PassRoles"
    actions = [
      "iam:PassRole"
    ]
    effect = "Allow"
    resources = [
      aws_iam_role.execution.arn,
      aws_iam_role.task.arn
    ]
  }
}
