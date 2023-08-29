output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnets" {
  description = "All subnets in the public routing class, by AZ"
  value       = { for k, v in aws_subnet.public : k => { id = v.id, cidr = v.cidr_block } }
}

output "private_subnets" {
  description = "All subnets in the private routing class, by AZ"
  value       = { for k, v in aws_subnet.private : k => { id = v.id, cidr = v.cidr_block } }
}

output "internal_subnets" {
  description = "All subnets in the internal routing class, by AZ"
  value       = { for k, v in aws_subnet.internal : k => { id = v.id, cidr = v.cidr_block } }
}

output "public_route_table" {
  description = "Public route table, if used"
  value       = local.provision_public_subnets ? aws_route_table.public["main"].id : ""
}

output "private_route_tables" {
  description = "Route tables used in private subnets"
  value       = { for k, v in aws_route_table.private : k => v.id }
}

output "internal_route_tables" {
  description = "Route tables used in internal subnets"
  value       = { for k, v in aws_route_table.internal : k => v.id }
}
