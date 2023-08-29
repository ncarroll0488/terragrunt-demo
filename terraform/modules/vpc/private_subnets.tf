resource "aws_subnet" "private" {
  for_each = local.private_subnet_definitions

  vpc_id               = aws_vpc.main.id
  cidr_block           = each.value
  availability_zone_id = each.key

  tags = {
    Name = "${var.vpc_name} Private ${each.key}"
  }
}

resource "aws_eip" "nat" {
  for_each = local.private_subnet_definitions

  domain = "vpc"

  tags = {
    Name = "EIP for ${var.vpc_name} NAT ${each.key}"
  }
}

resource "aws_nat_gateway" "main" {
  for_each = local.private_subnet_definitions

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  tags = {
    Name = "${var.vpc_name} NAT ${each.key}"
  }

  depends_on = [aws_internet_gateway.main]
}

resource "aws_route_table" "private" {
  for_each = local.private_subnet_definitions

  vpc_id = aws_vpc.main.id

  tags = {
    "Name" = "Route table for ${var.vpc_name} private ${each.key}"
  }
}

resource "aws_route" "private" {
  for_each               = local.private_subnet_definitions
  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main[each.key].id
}

resource "aws_route_table_association" "private" {
  for_each       = local.private_subnet_definitions
  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}
