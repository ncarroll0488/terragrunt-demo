// This is a "leaf" configuration file. The ordering of this file does not matter. Copy it to a directory above the
// root, renaming it to `terragrunt.hcl`.

// Inputs are the values given to terraform variables. You may interpolate locals and dependencies here
inputs = {
  vpc_id                    = dependency.vpc.outputs.vpc_id
  vpc_endpoint_services     = ["s3", "dynamodb"]
  vpc_endpoint_route_tables = values(dependency.vpc.outputs.internal_route_tables)
}

// Note: You cannot use `dependency` references in locals, but you can use locals in dependency blocks.
locals {
  // The name of the module you're pulling from source, such as "vpc". The / character is allowed
  module_name = "vpc_endpoint"

  // This will be the absolute path of the module source directory. We're using some string interpolation so that
  // this could be changed to source from a git repository in the rool HCL  without any extra work in leaf files.
  module_source_path = "${include.root.locals.module_source_path}/${local.module_name}"

  // The vast majority of includes will be done relative to the current environment. This will return the location of "environment.hcl"
  leaf_dependency_path = abspath(dirname(find_in_parent_folders("env.hcl")))
}

// Name this include block "root". Refer to locals in the root config with "include.root"
include "root" {

  // Expose this include to the rest of the HCL file, so we can use include.root
  expose = true

  // Traverse down the directory tree until we find the next 'terragrunt.hcl'
  path = find_in_parent_folders()
}

// The 'dependency' block can be specified many times, and is used to build a dependency tree as well as export data
// between individual leaves. Use `local.leaf_dependency_path` to eliminate long, ambiguous chains of relative
// paths (../../)


dependency "vpc" {
  config_path = "${local.leaf_dependency_path}/vpc/demo1"
}

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
