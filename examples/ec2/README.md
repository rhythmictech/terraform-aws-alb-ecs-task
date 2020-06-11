# EC2 Example
Creates an ECS service with ALB listener on existing AWS infrastructure.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alb\_security\_group\_id | n/a | `any` | n/a | yes |
| cluster\_name | n/a | `any` | n/a | yes |
| load\_balancer\_arn | n/a | `any` | n/a | yes |
| subnet\_ids | n/a | `any` | n/a | yes |
| vpc\_id | n/a | `any` | n/a | yes |

## Outputs

No output.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
