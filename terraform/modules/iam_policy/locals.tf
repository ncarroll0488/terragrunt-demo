locals {
  source_policy_documents   = [for doc in var.source_policy_documents : jsondecode(doc)]
  policy_statements         = [for statement in var.policy_statements : jsondecode(statement)]
  override_policy_documents = [for doc in var.override_policy_documents : jsondecode(doc)]
}
