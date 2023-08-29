output "task_role_arn" {
  description = "ARN of the task role"
  value       = aws_iam_role.task.arn
}

output "execution_role_arn" {
  description = "ARN of the execution role"
  value       = aws_iam_role.execution.arn
}

output "service_role_arn" {
  description = "ARN of the service role"
  value       = aws_iam_role.service.arn
}

output "ecs_cluster_arn" {
  description = "ARN of the ECS Cluster"
  value       = aws_ecs_cluster.main.arn
}

output "cloudwatch_log_group_arn" {
  description = "ARN of the cluster's cloudwatch log group"
  value       = aws_cloudwatch_log_group.main.arn
}
