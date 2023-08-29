resource "aws_cloudwatch_log_group" "main" {
  name_prefix = "ecs_${var.cluster_name}"

  tags = {
    Name = "Log group for ECS cluster: ${var.cluster_name}"
  }
}

