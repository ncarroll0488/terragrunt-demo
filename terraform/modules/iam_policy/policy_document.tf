data "aws_iam_policy_document" "main" {
  source_policy_documents = local.source_policy_documents

  /*
    Iterate through the list of statements and construct them using sane defaults.

    This method is intended for policy elements including resources from other modules, where terraform cannot
    rely on statically-defined ARNs.

    For static/wildcard policies, the source_policy_documents variable may be more suitable
  */

  dynamic "statement" {
    for_each = local.policy_statements
    // In this case, "statement" is the name of the iterator
    content {
      effect      = try(statement.value.effect, var.default_effect)
      actions     = try(statement.value.actions, null)
      not_actions = try(statement.value.not_actions, null)

      // This policy isn't especially useful without resources, so don't specify defaults
      resources = toset(statement.value.resources)

      // Seldom used, so null is a good default
      not_resources = try(statement.value.not_resources, null)

      // if no sid is provided, generate an ID from the statement
      sid = try(statement.value.sid, md5(jsonencode(statement)))

      // Create a condition block only if specified
      dynamic "condition" {
        for_each = can(statement.value.condition) ? ["a"] : []
        content {
          test     = condition["test"]
          values   = condition["values"]
          variable = condition["variable"]
        }
      }
    }
  }
}
