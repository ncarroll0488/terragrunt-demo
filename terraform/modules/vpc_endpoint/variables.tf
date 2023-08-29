variable "vpc_id" {
  description = "ID of the VPC in which to create the interface"
  type        = string
}

variable "vpc_endpoint_services" {
  description = "A list of services which will require an in-vpc service endpoint"
  default     = []
  type        = list(string)
}

variable "vpc_endpoint_subnets" {
  description = "A list of subnet IDs into which interface service endpoint interfaces will be placed"
  type        = list(string)
  default     = []
}

variable "vpc_endpoint_route_tables" {
  description = "A list of route tables to which gateway service endponts will be attached"
  type        = list(string)
  default     = []
}

variable "vpc_endpoint_interface_sg_ids" {
  description = "Security group IDs to assign to interface-based service endpoints"
  type        = list(string)
  default     = []
}

locals {
  gateway_services    = ["s3", "dynamodb"]
  interface_endpoints = { for a in setproduct(toset(var.vpc_endpoint_subnets), toset(var.vpc_endpoint_services)) : "${a[0]}-${a[1]}" => { "subnet" = a[0], "service" = a[1] } if !contains(local.gateway_services, a[1]) }
  gateway_endpoints   = { for a in setproduct(toset(var.vpc_endpoint_route_tables), toset(var.vpc_endpoint_services)) : "${a[0]}-${a[1]}" => { "route_table" = a[0], "service" = a[1] } if contains(local.gateway_services, a[1]) }
}

data "aws_region" "current" {
}
