resource "aws_subnet" "internal" {
  for_each = local.internal_subnet_definitions

  vpc_id               = aws_vpc.main.id
  cidr_block           = each.value
  availability_zone_id = each.key

  tags = {
    Name = "${var.vpc_name} Internal ${each.key}"
  }
}

resource "aws_route_table" "internal" {
  for_each = local.internal_subnet_definitions

  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = "Route table for ${var.vpc_name} internal ${each.key}"
  }
}

resource "aws_route_table_association" "internal" {
  for_each       = local.internal_subnet_definitions
  subnet_id      = aws_subnet.internal[each.key].id
  route_table_id = aws_route_table.internal[each.key].id
}
