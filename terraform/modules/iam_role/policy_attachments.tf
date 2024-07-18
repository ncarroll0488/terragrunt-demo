resource "aws_iam_role_policy_attachment" "main" {
  for_each   = toset(var.policy_arns)
  role       = aws_iam_role.main.name
  policy_arn = each.value
}
