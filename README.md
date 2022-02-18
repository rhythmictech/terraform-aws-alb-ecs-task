# terraform-aws-alb-ecs-task [![](https://github.com/rhythmictech/terraform-aws-alb-ecs-task/workflows/pre-commit-check/badge.svg)](https://github.com/rhythmictech/terraform-aws-alb-ecs-task/actions) <a href="https://twitter.com/intent/follow?screen_name=RhythmicTech"><img src="https://img.shields.io/twitter/follow/RhythmicTech?style=social&logo=twitter" alt="follow on Twitter"></a>
Creates an ECS service, ECS task, ALB target group, ALB listener, and CloudWatch logging. Ignores updates to the task so deployments can continue via another pipeline.

## Example
Here's what using the module will look like
```hcl
module "example" {
  source  = "rhythmictech/alb-ecs-task/aws"
  version = "1.1.0"

  cluster_name      = aws_ecs_cluster.example.name
  container_port    = 80
  container_image   = "docker.io/library/nginx:latest"
  load_balancer_arn = aws_lb.public.arn
  listener_port     = 80
  name              = module.tags.name
  subnets           = var.subnet_ids
  tags              = module.tags.tags
  vpc_id            = var.vpc_id
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.19 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.48.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 2.48.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_container_definition"></a> [container\_definition](#module\_container\_definition) | cloudposse/ecs-container-definition/aws | 0.58.1 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_service.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_role.ecs_exec](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ecs_task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.additional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_exec](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_exec_additional](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lb_listener_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_target_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_security_group.ecs_service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.allow_all_egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_iam_policy_document.assume](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_exec](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_ecs_service_exec_policy_arns"></a> [additional\_ecs\_service\_exec\_policy\_arns](#input\_additional\_ecs\_service\_exec\_policy\_arns) | ARNs for additional ECS Service Execution Role policies | `list(string)` | `[]` | no |
| <a name="input_additional_ecs_task_policy_arns"></a> [additional\_ecs\_task\_policy\_arns](#input\_additional\_ecs\_task\_policy\_arns) | ARNs for additional ECS task policies | `list(string)` | `[]` | no |
| <a name="input_alb_security_group_id"></a> [alb\_security\_group\_id](#input\_alb\_security\_group\_id) | ID for ALB Security Group | `string` | n/a | yes |
| <a name="input_assign_ecs_service_public_ip"></a> [assign\_ecs\_service\_public\_ip](#input\_assign\_ecs\_service\_public\_ip) | Assigns a public IP to your ECS service. Set true if using fargate, see https://aws.amazon.com/premiumsupport/knowledge-center/ecs-pull-container-api-error-ecr/ | `bool` | `false` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of ECS cluster | `string` | n/a | yes |
| <a name="input_container_image"></a> [container\_image](#input\_container\_image) | Container image, ie 203583890406.dkr.ecr.us-west-1.amazonaws.com/api-integrations:git-34752db | `string` | `"busybox"` | no |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | Defaults to `api-<var.name>` | `string` | `null` | no |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | Port on Container that main process is listening on | `number` | n/a | yes |
| <a name="input_environment_variables"></a> [environment\_variables](#input\_environment\_variables) | The environment variables to pass to the container. This is a list of maps | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `null` | no |
| <a name="input_health_check"></a> [health\_check](#input\_health\_check) | Target group health check, for LB to assess service health<br>See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#health_check | <pre>object({<br>    healthy_threshold   = number<br>    interval            = number<br>    path                = string<br>    port                = string<br>    protocol            = string<br>    unhealthy_threshold = number<br>  })</pre> | <pre>{<br>  "healthy_threshold": 3,<br>  "interval": 30,<br>  "path": "/",<br>  "port": "traffic-port",<br>  "protocol": "HTTP",<br>  "unhealthy_threshold": 3<br>}</pre> | no |
| <a name="input_host_header"></a> [host\_header](#input\_host\_header) | The hostname in the request which acts as condition for listener. See<br>https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule#host_header | `string` | n/a | yes |
| <a name="input_internal_protocol"></a> [internal\_protocol](#input\_internal\_protocol) | Protocol for traffic between the ALB and ECS. Should be one of [TCP, TLS, UDP, TCP\_UDP, HTTP, HTTPS] | `string` | `"HTTP"` | no |
| <a name="input_launch_type"></a> [launch\_type](#input\_launch\_type) | ECS service launch type: FARGATE \| EC2 | `string` | `"FARGATE"` | no |
| <a name="input_listener_arn"></a> [listener\_arn](#input\_listener\_arn) | ARN of listener on ALB | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Moniker to apply to all resources in module | `string` | n/a | yes |
| <a name="input_network_mode"></a> [network\_mode](#input\_network\_mode) | The Docker networking mode to use for the containers in the task. The valid values are none, bridge, awsvpc, and host. | `string` | `"awsvpc"` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | The secrets to pass to the container. This is a list of maps | <pre>list(object({<br>    name      = string<br>    valueFrom = string<br>  }))</pre> | `null` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | List of Security Group IDs to apply to the ECS Service | `list(string)` | `[]` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnets that should be added to ECS service network configuration | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Resource Tags. BE VERBOSE. Should AT MINIMIUM contain; Name & Owner | `map(string)` | `{}` | no |
| <a name="input_target_group_port"></a> [target\_group\_port](#input\_target\_group\_port) | The port on which targets receive traffic on the Target Group | `number` | `80` | no |
| <a name="input_task_cpu"></a> [task\_cpu](#input\_task\_cpu) | The number of cpu units used by the task. | `number` | `1024` | no |
| <a name="input_task_desired_count"></a> [task\_desired\_count](#input\_task\_desired\_count) | Number of copies of task definition that should be running at any given time | `number` | `1` | no |
| <a name="input_task_memory"></a> [task\_memory](#input\_task\_memory) | The amount (in MiB) of memory used by the task. | `number` | `2048` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID where resources will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cloudwatch_log_group"></a> [cloudwatch\_log\_group](#output\_cloudwatch\_log\_group) | aws\_cloudwatch\_log\_group resource |
| <a name="output_ecs_service"></a> [ecs\_service](#output\_ecs\_service) | aws\_ecs\_service resource |
| <a name="output_ecs_task_iam_role"></a> [ecs\_task\_iam\_role](#output\_ecs\_task\_iam\_role) | aws\_iam\_role resource for the ECS task |
| <a name="output_iam_role_ecs_service"></a> [iam\_role\_ecs\_service](#output\_iam\_role\_ecs\_service) | aws\_iam\_role resource for the ECS service |
| <a name="output_lb_target_group"></a> [lb\_target\_group](#output\_lb\_target\_group) | aws\_lb\_target\_group resource |
| <a name="output_lb_target_group_arn"></a> [lb\_target\_group\_arn](#output\_lb\_target\_group\_arn) | ARN for the target group associated with service |
| <a name="output_lb_target_group_id"></a> [lb\_target\_group\_id](#output\_lb\_target\_group\_id) | ID for the target group associated with service |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | Resource ID ofr Security Group associated with ECS Service network\_configuration |
| <a name="output_task_definition"></a> [task\_definition](#output\_task\_definition) | aws\_ecs\_task\_definition resource |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## The Giants underneath this module
- pre-commit.com/
- terraform.io/
- github.com/tfutils/tfenv
- github.com/segmentio/terraform-docs
