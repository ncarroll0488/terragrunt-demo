resource "aws_iam_instance_profile" "main" {
  // conditionally create this resource. It will be addressed as aws_iam_instance_profile.main['main']
  for_each = toset(var.create_ec2_instance_profile ? ["main"] : [])
  name     = aws_iam_role.main.name
  role     = aws_iam_role.main.name
}
