variable "vpc_name" {
  type        = string
  default     = "Main VPC"
  description = "Name of the VPC. Used in tags"
}

variable "primary_cidr" {
  type        = string
  description = "Primary VPC CIDR"
}

variable "provision_public_subnets" {
  type        = bool
  default     = false
  description = "Enables provisioning of public subnets, which use an IGW to get to the internet"
}

variable "provision_private_subnets" {
  type        = bool
  default     = false
  description = "Enables provisioning of private subnets, which use a NGW to get to the internet. This also enables public subnets"
}

variable "provision_internal_subnets" {
  type        = bool
  default     = false
  description = "Enables provisioning of internal subnets, which do not have internet access"
}

variable "public_subnet_cidr" {
  type        = string
  default     = ""
  description = "Provision the public subnets from this CIDR."
}

variable "private_subnet_cidr" {
  type        = string
  default     = ""
  description = "Provision the private subnets from this CIDR."
}

variable "internal_subnet_cidr" {
  type        = string
  default     = ""
  description = "Provision the internal subnets from this CIDR."
}

variable "pad_cidrs" {
  type        = bool
  default     = true
  description = "Leave gaps between unused availabiity zones and subnet classes."
}

variable "ignore_availability_zone_ids" {
  type        = list(string)
  default     = []
  description = "Ignore these availability zones. Note that changing this setting may result in lots of resources being replaced"
}

variable "desired_availability_zones" {
  type        = number
  default     = 3
  description = "How many availability zones to use. The module will fail if there aren't enough AZs"
}

variable "additional_cidrs" {
  type        = list(string)
  default     = []
  description = "Additional VPC CIDRs not otherwise specified"
}
