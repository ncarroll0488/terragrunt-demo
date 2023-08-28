locals {
  # Default all global operations to us-east-1, even though it doesn't really matter for most things.
  region = get_env("AWS_DEFAULT_REGION", "us-east-1")
}
