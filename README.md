# terraform-aws-alb-ecs-task [![](https://github.com/rhythmictech/terraform-aws-alb-ecs-task/workflows/pre-commit-check/badge.svg)](https://github.com/rhythmictech/terraform-aws-alb-ecs-task/actions) <a href="https://twitter.com/intent/follow?screen_name=RhythmicTech"><img src="https://img.shields.io/twitter/follow/RhythmicTech?style=social&logo=RhythmicTech" alt="follow on Twitter"></a>
Creates an ECS service, ECS task, ALB target group, ALB listener, and CloudWatch logging. Ignores updates to the task so deployments can continue via another pipeline.

## Example
Here's what using the module will look like
```hcl
module "example" {
  source = "github.com/rhythmictech/terraform-aws-alb-ecs-task?ref=master"

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
| terraform | >= 0.12.19 |
| aws | ~> 2.48.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.48.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alb\_security\_group\_id | ID for ALB Security Group | `string` | n/a | yes |
| cluster\_name | Name of ECS cluster | `string` | n/a | yes |
| container\_port | Port on Container that main process is listening on | `number` | n/a | yes |
| listener\_port | Port LB listener will be created on & external port which will receive traffic | `number` | n/a | yes |
| load\_balancer\_arn | ARN of load balancer which API will be attached to | `string` | n/a | yes |
| name | Moniker to apply to all resources in module | `string` | n/a | yes |
| vpc\_id | VPC ID where resources will be created | `string` | n/a | yes |
| additional\_ecs\_task\_policy\_arns | ARNs for additional ECS task policies | `list(string)` | `[]` | no |
| assign\_ecs\_service\_public\_ip | Assigns a public IP to your ECS service. Set true if using fargate, see https://aws.amazon.com/premiumsupport/knowledge-center/ecs-pull-container-api-error-ecr/ | `bool` | `false` | no |
| container\_image | Container image, ie 203583890406.dkr.ecr.us-west-1.amazonaws.com/api-integrations:git-34752db | `string` | `"busybox"` | no |
| container\_name | Defaults to `api-<var.name>` | `string` | `null` | no |
| environment\_variables | The environment variables to pass to the container. This is a list of maps | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `null` | no |
| health\_check | Target group health check, for LB to assess service health | <pre>object({<br>    port                = string<br>    protocol            = string<br>    healthy_threshold   = number<br>    unhealthy_threshold = number<br>    interval            = number<br>  })</pre> | <pre>{<br>  "healthy_threshold": 3,<br>  "interval": 30,<br>  "port": "traffic-port",<br>  "protocol": "HTTP",<br>  "unhealthy_threshold": 3<br>}</pre> | no |
| launch\_type | ECS service launch type: FARGATE \| EC2 | `string` | `"FARGATE"` | no |
| network\_mode | The Docker networking mode to use for the containers in the task. The valid values are none, bridge, awsvpc, and host. | `string` | `"awsvpc"` | no |
| secrets | The secrets to pass to the container. This is a list of maps | <pre>list(object({<br>    name      = string<br>    valueFrom = string<br>  }))</pre> | `null` | no |
| security\_group\_ids | List of Security Group IDs to apply to the ECS Service | `list(string)` | `[]` | no |
| subnets | Subnets that should be added to ECS service network configuration | `list(string)` | `[]` | no |
| tags | Resource Tags. BE VERBOSE. Should AT MINIMIUM contain; Name & Owner | `map(string)` | `{}` | no |
| target\_group\_port | The port on which targets receive traffic on the Target Group | `number` | `80` | no |
| task\_cpu | The number of cpu units used by the task. | `number` | `1024` | no |
| task\_desired\_count | Number of copies of task definition that should be running at any given time | `number` | `1` | no |
| task\_memory | The amount (in MiB) of memory used by the task. | `number` | `2048` | no |

## Outputs

| Name | Description |
|------|-------------|
| cloudwatch\_log\_group | aws\_cloudwatch\_log\_group resource |
| ecs\_service | aws\_ecs\_service resource |
| ecs\_task\_iam\_role | aws\_iam\_role resource for the ECS task |
| iam\_role\_ecs\_service | aws\_iam\_role resource for the ECS service |
| lb\_target\_group | aws\_lb\_target\_group resource |
| task\_definition | aws\_ecs\_task\_definition resource |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## The Giants underneath this module
- pre-commit.com/
- terraform.io/
- github.com/tfutils/tfenv
- github.com/segmentio/terraform-docs
