resource "aws_subnet" "public" {
  for_each             = local.public_subnet_definitions
  vpc_id               = aws_vpc.main.id
  cidr_block           = each.value
  availability_zone_id = each.key

  tags = {
    Name = "${var.vpc_name} Public ${each.key}"
  }
}

resource "aws_internet_gateway" "main" {
  for_each = toset(local.provision_public_subnets ? ["main"] : [])

  tags = {
    Name = "${var.vpc_name} IGW"
  }
}

resource "aws_internet_gateway_attachment" "main" {
  for_each            = toset(local.provision_public_subnets ? ["main"] : [])
  internet_gateway_id = aws_internet_gateway.main["main"].id
  vpc_id              = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  for_each = toset(local.provision_public_subnets ? ["main"] : [])
  vpc_id   = aws_vpc.main.id

  tags = {
    "Name" = "Route table for ${var.vpc_name} public subnets"
  }
}

resource "aws_route" "public" {
  for_each               = toset(local.provision_public_subnets ? ["main"] : [])
  route_table_id         = aws_route_table.public["main"].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main["main"].id
}

resource "aws_route_table_association" "public" {
  for_each       = local.public_subnet_definitions
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public["main"].id
}

