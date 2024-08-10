## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| override\_policy\_documents | A list of JSON strings containing policy statements, merged after var.statements | `list(string)` | `[]` | no |
| policy\_description | Description of the intent of this policy | `string` | n/a | yes |
| policy\_name\_prefix | Start the policy name with this string | `string` | n/a | yes |
| policy\_path | Place the policy under this path | `string` | `"/"` | no |
| policy\_statements | A list of JSON-formated policy elements which are assembled on-the fly. Use this for when terraform cannot rely merely on static policies | `list(string)` | `[]` | no |
| source\_policy\_documents | A list of JSON strings containing policy statements, merged before var.statements | `list(string)` | `[]` | no |

## Outputs

No output.

