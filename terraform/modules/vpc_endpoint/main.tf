resource "aws_vpc_endpoint" "interface" {
  for_each            = toset([for a in var.vpc_endpoint_services : a if !contains(local.gateway_services, a)])
  vpc_id              = var.vpc_id
  auto_accept         = true
  private_dns_enabled = true
  security_group_ids  = var.vpc_endpoint_interface_sg_ids
  service_name        = format("com.amazonaws.%s.%s", data.aws_region.current.name, each.value)
  vpc_endpoint_type   = "Interface"
  tags = {
    Name = format("%s endpoint for %s", each.value, var.vpc_id)
  }
}

resource "aws_vpc_endpoint_subnet_association" "interface" {
  for_each        = local.interface_endpoints
  vpc_endpoint_id = aws_vpc_endpoint.interface[each.value.service].id
  subnet_id       = each.value.subnet
}

resource "aws_vpc_endpoint" "gateway" {
  for_each          = toset([for a in var.vpc_endpoint_services : a if contains(local.gateway_services, a)])
  vpc_id            = var.vpc_id
  auto_accept       = true
  service_name      = format("com.amazonaws.%s.%s", data.aws_region.current.name, each.value)
  vpc_endpoint_type = "Gateway"
  tags = {
    Name = format("%s endpoint for %s", each.value, var.vpc_id)
  }
}

resource "aws_vpc_endpoint_route_table_association" "gateway" {
  for_each        = local.gateway_endpoints
  route_table_id  = each.value.route_table
  vpc_endpoint_id = aws_vpc_endpoint.gateway[each.value.service].id
}
