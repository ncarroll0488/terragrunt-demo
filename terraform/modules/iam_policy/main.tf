resource "aws_iam_policy" "main" {
  name_prefix = var.policy_name_prefix
  path        = var.policy_path
  description = var.policy_description
  policy      = data.aws_iam_policy_document.main.json
}
