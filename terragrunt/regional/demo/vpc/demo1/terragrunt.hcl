// This is a "leaf" configuration file. The ordering of this file does not matter. Copy it to a directory above the
// root, renaming it to `terragrunt.hcl`.

// Inputs are the values given to terraform variables. You may interpolate locals and dependencies here
inputs = {
  # Name the VPC after the current directory
  vpc_name = basename(get_terragrunt_dir())
  primary_cidr = one(
    [for k, v in dependency.ip_allocation.outputs.ip_inventory : k if v == {
      "account" = include.root.locals.aws_account_id,
      "env"     = include.root.locals.environment_name,
      "region"  = include.root.locals.aws_region,
      "vpcname" = basename(get_terragrunt_dir())
      }
    ]
  )

  provision_public_subnets   = true
  provision_private_subnets  = true
  provision_internal_subnets = true
}

// Note: You cannot use `dependency` references in locals, but you can use locals in dependency blocks.
locals {
  // The name of the module you're pulling from source, such as "vpc". The / character is allowed
  module_name = "vpc"

  // This will be the absolute path of the module source directory. We're using some string interpolation so that
  // this could be changed to source from a git repository in the rool HCL  without any extra work in leaf files.
  module_source_path = "${include.root.locals.module_source_path}/${local.module_name}"

  // The vast majority of includes will be done relative to the current environment. This will return the location of "environment.hcl"
  leaf_dependency_path = dirname(abspath(find_in_parent_folders("env.hcl")))
}

// Name this include block "root". Refer to locals in the root config with "include.root"
include "root" {

  // Expose this include to the rest of the HCL file, so we can use include.root
  expose = true

  // Traverse down the directory tree until we find the next 'terragrunt.hcl'
  path = find_in_parent_folders()
}

dependency "ip_allocation" {
  config_path = "${local.leaf_dependency_path}/vpc_ip_allocations"
}

// The 'dependency' block can be specified many times, and is used to build a dependency tree as well as export data
// between individual leaves. Use `local.leaf_dependency_path` to eliminate long, ambiguous chains of relative
// paths (../../)
/*
dependency "foo" {
  config_path = "${local.leaf_dependency_path}/path_to/some_leaf"
}
*/

// The 'dependencies' block is only needed if terragrunt needs to run leaves in a particular order, but there's no 
// explicit dependency between them. An example of this is using wait_for_steady_state in several ECS services which
// would otherwise come online in parallel. This option is not used as frequently as "dependency"
/*
dependencies {
  paths = []
}
*/

terraform {
  source = local.module_source_path
}
