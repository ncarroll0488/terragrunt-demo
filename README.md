# What this does
This is a demo of a basic terraform/terragrunt integration supporting a multi-region deploy. It will create:
* An instance of module which deterministically emits CIDRs based on region, environment, VPC name
    * This is configured in `terragrunt/regional/demo/vpc_ip_allocations`
* A VPC with 9 subnets, with 3 each having default routes pointing IGW, NAT, null
    * This is configured in `terragrunt/regional/demo/vpc/demo1`
* VPC endpoints to access the S3 and DynamoDB services
    * This is configured in `terragrunt/regional/demo/vpc_endpoints/demo1`

This is not designed to create any useful infrastructure. Rather, this serves to demonstrate how terragrunt manages dependencies.

# Usage
## Prerequisites
* `docker-compose`
## Instructions
1) Run `docker-compose run --rm terragrunt`
1) cd into the `regional` directory
1) Run `terragrunt run-all apply`

note that this deployment exists soley on localstack, so no real infrastructure will be created. there is additional module configuration for ecs, but localstack community does not support ECS as of now.
