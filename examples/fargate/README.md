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
| subnet\_ids | n/a | `any` | n/a | yes |
| vpc\_id | ####################################### Tags and Naming ####################################### | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| dns\_name | DNS name of ALB |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
