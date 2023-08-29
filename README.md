# What this does
This is a demo of a basic terraform/terragrunt integration supporting a multi-region deploy. It will create:
* A VPC with 3 local-only (no internet) subnets, with accompanying route tables.
    * This is configured in `terragrunt/regional/demo/vpc/demo`
* VPC endpoints to access the S3 and DynamoDB services
    * This is configured in `terragrunt/regional/demo/vpc_endpoints/demo`
* An ECS fargate cluster with Service, Executuion, and Task roles and accompanying IAM policies
    * This is configured in `terragrunt/regional/demo/ecs/clusters/demo`

# How to use this
1) Install [Terraform](https://developer.hashicorp.com/terraform/downloads)
1) Install [Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/install/)
1) Authenticate to AWS. You must set an `AWS_DEFAULT_REGION`. Use `aws sts get-caller-identity` to test
1) cd into `terragrunt/regional`
1) Run `terragrunt run-all apply`
1) You may be asked to create a state bucket, do so.
1) Answer yes if you wish to create everything

This deployment should not cost anything on a live AWS environment, however it's recommended to use `terragrunt run-all destroy` to remove infrastrucure when done demoing. You may wish to use something like [Localstack](https://localstack.cloud), however this may require extensive modification of the root terragrunt HCL's provider and backend blocks.
