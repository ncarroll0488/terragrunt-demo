## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create\_ec2\_instance\_profile | Create an EC2 instance profile for use with instance role attachment | `bool` | `false` | no |
| inline\_policy | A JSON document containing policy elements attached to this role only. | `string` | `""` | no |
| permissions\_boundary\_policy\_arn | ARN of the policy that is used to set the permissions boundary for the role. | `string` | `null` | no |
| policy\_arns | A list of policies to attach to this role | `list(string)` | `[]` | no |
| role\_name\_prefix | Begin the name of the role with this string | `string` | n/a | yes |
| role\_path | Place the role under this path | `string` | `"/"` | no |
| trusted\_identities | A list of AWS identity (users, intance profiles, etc.) ARNs which can assume this role | `list(string)` | <pre>[<br>  "arn:aws:iam::255747449854:user/users/ncarroll"<br>]</pre> | no |
| trusted\_saml\_providers | A list of SAML providers who may assume this identity | `list(string)` | `[]` | no |
| trusted\_services | A list of AWS services (ec2, s3, and so on) which can assume this role | `list(string)` | <pre>[<br>  "ecs"<br>]</pre> | no |

## Outputs

No output.

