# Fargate Example
Creates a public ALB, ECS cluster, and example Fargate service. All you need to do is provide the `vpc_id` and the `subnet_ids`.

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
