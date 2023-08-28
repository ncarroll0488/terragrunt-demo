locals {
  # Default to us-east-2 (Ohio) for regional deployments
  aws_region = get_env("AWS_DEFAULT_REGION", "us-east-2")
}
