locals {
  # Name the environment after the directory it's in
  environment_name = basename(get_terragrunt_dir())
}
