########################################
# Tags and Naming
########################################
variable "vpc_id" {}
variable "subnet_ids" {}
locals {
  env       = "sandbox"
  name      = "example"
  namespace = "aws-rhythmic-sandbox"
  owner     = "Rhythmictech Engineering"
  region    = "us-east-1"

  extra_tags = {
    delete_me = "please"
    purpose   = "testing"
  }
}

module "tags" {
  source  = "rhythmictech/tags/terraform"
  version = "1.0.0"

  names = [local.name, local.env, local.namespace]

  tags = merge({
    "Env"       = local.env,
    "Namespace" = local.namespace,
    "Owner"     = local.owner
  }, local.extra_tags)
}

########################################=
#  ECS and ALB
########################################=
resource "aws_ecs_cluster" "example" {
  name = module.tags.name
  tags = module.tags.tags
}

resource "aws_security_group" "alb" {
  description = "Example rule for ALB"
  name_prefix = "${local.name}-sg-"
  tags        = module.tags.tags
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "allow_all_http_ingress" {
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:AWS006
  description       = "Allow everything to access our example"
  from_port         = 80
  protocol          = "-1"
  security_group_id = aws_security_group.alb.id
  to_port           = 80
  type              = "ingress"
}

resource "aws_security_group_rule" "allow_all_egress" {
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:AWS007
  description       = "Allow our example to egress anywhere"
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.alb.id
  to_port           = 0
  type              = "egress"
}

resource "aws_lb" "public" {
  internal           = false #tfsec:ignore:AWS005
  load_balancer_type = "application"
  name               = "${local.name}-external-alb"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.subnet_ids
  tags               = module.tags.tags
}

########################################
# Example module invocation
########################################
module "example" {
  source = "../.."

  alb_security_group_id        = aws_security_group.alb.id
  assign_ecs_service_public_ip = true
  cluster_name                 = aws_ecs_cluster.example.name
  container_port               = 80
  container_image              = "docker.io/library/nginx:alpine"
  load_balancer_arn            = aws_lb.public.arn
  listener_port                = 80
  name                         = module.tags.name
  subnets                      = var.subnet_ids
  tags                         = module.tags.tags
  vpc_id                       = var.vpc_id
}

output "example_module" {
  description = "the whole module"
  value       = module.example
}

output "dns_name" {
  description = "DNS name of ALB"
  value       = aws_lb.public.dns_name
}
