variable "role_name_prefix" {
  type        = string
  description = "Begin the name of the role with this string"
}

variable "role_path" {
  type        = string
  description = "Place the role under this path"
  default     = "/"
  validation {
    condition     = startswith(var.role_path, "/") && endswith(var.role_path, "/")
    error_message = "The role_path must start and end with '/'."
  }
}

variable "policy_arns" {
  type        = list(string)
  description = "A list of policies to attach to this role"
  default     = []
}

variable "trusted_services" {
  type        = list(string)
  description = "A list of AWS services (ec2, s3, and so on) which can assume this role"
  default     = []
}

variable "trusted_identities" {
  type        = list(string)
  description = "A list of AWS identity (users, intance profiles, etc.) ARNs which can assume this role"
  default     = []
}

variable "trusted_saml_providers" {
  type        = list(string)
  description = "A list of SAML providers who may assume this identity"
  default     = []
}

variable "inline_policy" {
  type        = string
  description = "A JSON document containing policy elements attached to this role only."
  default     = ""
}

variable "create_ec2_instance_profile" {
  type        = bool
  description = "Create an EC2 instance profile for use with instance role attachment"
  default     = false
}

variable "permissions_boundary_policy_arn" {
  type        = string
  description = "ARN of the policy that is used to set the permissions boundary for the role."
  default     = null
}
