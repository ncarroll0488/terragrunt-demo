variable "cluster_name" {
  type        = string
  description = "Name of the cluster, used in tagging and IAM elements"
}

variable "task_role_policies" {
  type        = list(string)
  description = "A list of policy ARNs to attach to the task role"
  default     = []
}

variable "container_insights" {
  type        = bool
  description = "Enabled container insights"
  default     = true
}

variable "iam_entity_path" {
  type        = string
  description = "Put IAM entities under this path"
  default     = null
}

variable "ecr_repos" {
  type        = list(string)
  description = "List of ECR Repos accessible by this cluster. Defaults to *"
  default     = ["*"]
}

variable "task_definition_arns" {
  type        = list(string)
  description = "Restrict the service role to these task definition ARNs"
  default     = ["*"]
}
