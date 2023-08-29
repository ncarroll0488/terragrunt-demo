## Description
This module creates VPC service endpoints for secure access to AWS services. 
!!! WARNING !!! Interface-based service endpoints can be expensive

## Usage
Simply provide a list of services, and this module will create the appropriate type of endpoint for you. Region is automatically determined as well. For services that require a gateway-type endpoint (S3, DynamoDB), this module will need a list of route tables provided. For services that require an interface endpoint, a list of security groups and subnets must be provided. A mix of interface and gateway-based services may be provided all at once.

## Examples
### Interface-only
This creates service endpoints for EC2 and ECR and associates private DNS into the VPC for access.
```hcl
module "endpoints" {
  source = "../../module/vpc_endpoint"
  vpc_id = "vpc-123"
  endpoints = ["ec2", "ecr"]
  subnets = ["subnet-1", "subnet-2"]
  interface_sg_ids = ["sg-123"]
}
```

### Gateway-only
This creates service endpoints for S3 and DynamoDB and modifies route tables to point to the endpoint
```hcl
module "endpoints" {
  source = "../../module/vpc_endpoint"
  vpc_id = "vpc-123"
  endpoints = ["s3", "dynamodb"]
  route_tables = ["rtb-1", "rtb-2"]
}
```

### Both
This will create service endpoints for all of S3, Dynamo, ECS, ECR. Route tables are adjusted for S3 and Dynamo. DNS is added for ECS and ECR
```hcl
module "endpoints" {
  source = "../../module/vpc_endpoint"
  vpc_id = "vpc-123"
  endpoints = ["s3", "dynamodb", "ec2", "ecr"]
  subnets = ["subnet-1", "subnet-2"]
  interface_sg_ids = ["sg-123"]
  route_tables = ["rtb-1", "rtb-2"]
}
```
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc\_endpoint\_id | ID of the VPC in which to create the interface | `string` | n/a | yes |
| vpc\_endpoint\_interface\_sg\_ids | Security group IDs to assign to interface-based service endpoints | `list(string)` | `[]` | no |
| vpc\_endpoint\_route\_tables | A list of route tables to which gateway service endponts will be attached | `list(string)` | n/a | yes |
| vpc\_endpoint\_services | A list of services which will require an in-vpc service endpoint | `list(string)` | `[]` | no |
| vpc\_endpoint\_subnets | A list of subnet IDs into which interface service endpoint interfaces will be placed | `list(string)` | n/a | yes |

## Outputs

No output.

