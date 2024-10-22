# This config is intentionally very short, and does not include the root HCL file, as the AWS provider isn't needed.

inputs = {
  # Name the VPC after the current directory
  json_documents = ["demo.json"]
}

terraform {
  source = "git::https://github.com/ncarroll0488/terraform-modules.git//src/generic/ip_allocation"
}
