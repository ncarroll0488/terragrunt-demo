locals {
  # Name the environment after the directory it's in
  environment_name = basename(dirname(abspath(".")))
}
