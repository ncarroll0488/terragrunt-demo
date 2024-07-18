// Create a trust policy document. This datasource formats everything for us and validates syntax.
data "aws_iam_policy_document" "trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    // Use a dynamic so we don't have an empty principals statement
    dynamic "principals" {
      for_each = range(0, max(length(local.trusted_services), 1))
      content {
        type        = "Service"
        identifiers = [for service_name in toset(local.trusted_services) : format("%s.amazonaws.com", service_name)]
      }
    }

    dynamic "principals" {
      for_each = range(0, max(length(local.trusted_identities), 1))
      content {
        type        = "AWS"
        identifiers = local.trusted_identities
      }
    }

    dynamic "principals" {
      for_each = range(0, max(length(local.trusted_saml_providers), 1))
      content {
        type        = "Federated"
        identifiers = local.trusted_saml_providers
      }
    }
  }
}

resource "aws_iam_role" "main" {
  name_prefix        = var.role_name_prefix
  path               = var.role_path
  assume_role_policy = data.aws_iam_policy_document.trust_policy.json
}

resource "aws_iam_role_policy" "main" {
  for_each = toset(var.inline_policy == "" ? [] : ["main"])
  name     = aws_iam_role.main.name
  role     = aws_iam_role.main.id
  policy   = var.inline_policy
}
