variable "policy_name_prefix" {
  type        = string
  description = "Start the policy name with this string"
}

variable "policy_description" {
  type        = string
  description = "Description of the intent of this policy"
}

variable "policy_path" {
  type        = string
  description = "Place the policy under this path"
  default     = "/"
  validation {
    condition     = startswith(var.policy_path, "/") && endswith(var.policy_path, "/")
    error_message = "The policy_path must start and end with '/'."
  }
}

variable "source_policy_documents" {
  type        = list(string)
  description = "A list of JSON strings containing policy statements, merged before var.statements"
  default     = []
}

variable "policy_statements" {
  type        = list(string)
  description = "A list of JSON-formated policy elements which are assembled on-the fly. Use this for when terraform cannot rely merely on static policies"
  default     = []
}

variable "override_policy_documents" {
  type        = list(string)
  description = "A list of JSON strings containing policy statements, merged after var.statements"
  default     = []
}

variable "default_effect" {
  type        = string
  description = "The default effect of a policy statement if none is given. Falls back on provider defaults if unspecified."
  default     = null
  validation {
    condition     = var.default_effect == null || var.default_effect == "Allow" || var.default_effect == "Deny"
    error_message = "The default effect must be 'Allow' or 'Deny'"
  }
}
