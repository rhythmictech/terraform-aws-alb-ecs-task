# Fargate Example
Creates a public ALB, ECS cluster, and example Fargate service. All you need to do is provide the `vpc_id` and the `subnet_ids`.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_example"></a> [example](#module\_example) | ../.. |  |
| <a name="module_tags"></a> [tags](#module\_tags) | rhythmictech/tags/terraform | 1.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_ecs_cluster.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_lb.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_security_group.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.allow_all_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.allow_all_http_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | n/a | `any` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | ####################################### Tags and Naming ####################################### | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dns_name"></a> [dns\_name](#output\_dns\_name) | DNS name of ALB |
| <a name="output_example_module"></a> [example\_module](#output\_example\_module) | the whole module |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
