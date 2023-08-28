locals {
  // Populate "accounts.json" with a list of allowed AWS account IDs.
  allowed_account_ids = join(",", try(jsondecode(file("accounts.json")), [get_aws_account_id()]))

  // Determine necessary region, and environment-level variables from their corresponding HCL files
  region_vars      = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  // This will be necessary
  aws_region  = local.region_vars.locals.aws_region
  environment = local.environment_vars.locals.environment

  // This will be the path between the root and the leaf terragrunt.hcl. This is tagged to all resources automatically, and makes it easier to find exactly which config file provisions a resource.
  auto_tag_tg_leaf = path_relative_to_include()

  // If for some reason you want to store your S3 state in another account, set this. This does not affect the name of the bucket
  s3_state_bucket_account_id = get_env("S3_STATE_BUCKET_ACCOUNT_ID", get_aws_account_id())

  // This configures the region where state files are stored. By default, it's the current region. This does not affect the name of the bucket.
  s3_state_bucket_region = get_env("S3_STATE_BUCKET_REGION", local.aws_region)

  // This overrides the name of the lock table. You probably don't need to change this.
  dynamodb_lock_table = get_env("DYNAMODB_LOCK_TABLE", "terraform-locks")

  // This is the path of the terraform module source directory. It can be a github repo, or in this case
  // a simple relative directory path.
  module_source_path = abspath("../terraform/modules")

  // This is the directory from which 
  terragrunt_base_dir = abspath(".")
}

// Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.aws_region}"
  // Only these AWS Account IDs may be operated on by this template
  allowed_account_ids = [${local.allowed_account_ids}]

  // Automatically add tags. This saves us having to explicitly support tags in every module.
  default_tags {
    tags = {
      TERRAGRUNT_ENV     = "${local.environment}"
      TERRAGRUNT_LEAF    = "${local.auto_tag_tg_leaf}"
    }
  }
}
EOF
}

// Add some default outputs to all terraform modules. This information helps simplify adding some resources.
// For instance, an AWS VPC peering connection needs both pieces of information.
generate "default_outputs" {
  path      = "__tg_default_outputs.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
outputs {
  __aws_account_id = "${get_aws_account_id()}"
  __aws_region = "${local.aws_region}"
}
EOF
}

// Configure Terragrunt to automatically store tfstate files in an S3 bucket with dynamoDB locking
remote_state {
  backend = "s3"
  config = {
    encrypt        = true
    bucket         = "terraform-state-${local.s3_state_bucket_account_id}-${local.aws_region}-${local.environment}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.s3_state_bucket_region
    dynamodb_table = local.dynamodb_lock_table
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

// Previously, account, environment, and region HCLs were merged as inputs here.
// With modern versions of terragrunt, the leaf can reference specific members of these objects by referencing the
// object 'include.root.locals.some_local_value'. This makes for cleaner leaf configuration and less boilerplate.
//
// If there are any inputs which should be applied to *every single* leaf, add them here but this is not recommended
// as it leads to unexpected behavior. You can merge (left-to-right, or to-to-bottom) any number hashes, either by
// reference or explicitly
/*
inputs = merge(
  locals.some_hash,
  locals.another_hash,
  {
    key1 = "val1"
    key2 = "val2"
    key3 = somefunction(val3)
  }
)
*/
