locals {
  # Get a list of availability zones, minus the ignored ones
  availability_zone_ids = sort(tolist(setsubtract(data.aws_availability_zones.az.zone_ids, var.ignore_availability_zone_ids)))

  # Get a count of AZs
  availability_zone_count = length(local.availability_zone_ids)

  # Make a list of extra CIDRs which need to be added
  vpc_additional_cidrs = flatten([compact([var.public_subnet_cidr, var.private_subnet_cidr, var.internal_subnet_cidr]), var.additional_cidrs])

  # If we've enabled padding, pretend there are `availability_zone_count` total AZs when calculating subnet size
  subnet_allocation_width = var.pad_cidrs ? local.availability_zone_count : var.desired_availability_zones

  # The full list of AZs which could be used, for padding
  allocate_azs = slice(local.availability_zone_ids, 0, local.subnet_allocation_width)

  # The full list of AZs which will be used
  provision_azs = slice(local.availability_zone_ids, 0, var.desired_availability_zones)

  # We have to enable public subnets if we're using private subnets
  provision_public_subnets = var.provision_public_subnets || var.provision_private_subnets

  # The other two as locals, for consistency
  provision_private_subnets  = var.provision_private_subnets
  provision_internal_subnets = var.provision_internal_subnets

  # Set the CIDR used by each routing class.
  public_cidr   = coalesce(var.public_subnet_cidr, var.primary_cidr)
  private_cidr  = coalesce(var.private_subnet_cidr, var.primary_cidr)
  internal_cidr = coalesce(var.internal_subnet_cidr, var.primary_cidr)

  all_cidrs = distinct([var.primary_cidr, local.public_cidr, local.private_cidr, local.internal_cidr])

  # Used to calculate CIDR sizes
  subnet_type_count = var.pad_cidrs ? 3 : length(compact([
    local.provision_public_subnets ? "a" : "",
    local.provision_private_subnets ? "a" : "",
    local.provision_internal_subnets ? "a" : ""
  ]))

  # Now, do some math. This is intentionally deliberate.
  # First thing we do is figure out how many subnets are being allocated in the main cidr.
  # This is the number of routing classes (up to 3) using the main CIDR, multiplied by our allocation width
  subnets_in_primary_cidr = (local.subnet_type_count - length(setsubtract(compact(local.all_cidrs), [var.primary_cidr]))) * local.subnet_allocation_width

  # Now, split off the CIDRs into individual bits
  primary_cidr_nbits = split("/", var.primary_cidr)[1]

  # In a CIDR netmask, the nbits value represents half as many addresses every time the value goes up by 1
  # /28 = 16 address. /29 = 8 addresses, and so on.
  # This is why log-base-2 is used to figure out how many more bits to add to the prefix
  primary_cidr_subnet_nbits = max(ceil(log(local.subnets_in_primary_cidr, 2)), 0)

  # The same calculation, but done vs subnet allocation width, for subnets which use their own CIDRs
  non_primary_cidr_subnet_nbits = ceil(log(local.subnet_allocation_width, 2))

  # Figure out the nbits for each subnet
  public_cidr_nbits   = split("/", local.public_cidr)[1]
  private_cidr_nbits  = split("/", local.private_cidr)[1]
  internal_cidr_nbits = split("/", local.internal_cidr)[1]

  # If these subnets go into the main CIDR, use the main cidr nbits
  public_cidr_subnet_nbits   = local.public_cidr == var.primary_cidr ? local.primary_cidr_subnet_nbits : local.non_primary_cidr_subnet_nbits
  private_cidr_subnet_nbits  = local.private_cidr == var.primary_cidr ? local.primary_cidr_subnet_nbits : local.non_primary_cidr_subnet_nbits
  internal_cidr_subnet_nbits = local.internal_cidr == var.primary_cidr ? local.primary_cidr_subnet_nbits : local.non_primary_cidr_subnet_nbits

  # Create 3 hashes of az_id => CIDR
  public_subnet_definitions = local.provision_public_subnets ? {
    for az in local.provision_azs : az => cidrsubnet(
      local.public_cidr,
      local.public_cidr_subnet_nbits,
      index(local.provision_azs, az)
    )
  } : {}

  private_subnet_definitions = local.provision_private_subnets ? {
    for az in local.provision_azs : az => cidrsubnet(
      local.private_cidr,
      local.private_cidr_subnet_nbits,
      local.subnet_allocation_width + index(local.provision_azs, az)
    )
  } : {}

  internal_subnet_definitions = local.provision_internal_subnets ? {
    for az in local.provision_azs : az => cidrsubnet(
      local.internal_cidr,
      local.internal_cidr_subnet_nbits,
      (2 * local.subnet_allocation_width) + index(local.provision_azs, az)
    )
  } : {}
}
