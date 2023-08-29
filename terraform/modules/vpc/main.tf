resource "aws_vpc" "main" {
  cidr_block = var.primary_cidr
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_vpc_ipv4_cidr_block_association" "additional" {
  for_each   = toset(local.vpc_additional_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block = each.value
}
