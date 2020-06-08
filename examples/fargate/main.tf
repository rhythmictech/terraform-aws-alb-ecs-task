########################################
# Tags and Naming
########################################
variable "vpc_id" {}
variable "subnets" {}
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

resource "aws_lb" "public" {
  internal           = false #tfsec:ignore:AWS005
  load_balancer_type = "application"
  name               = "${local.name}-external-alb"
  subnets            = var.subnets
  tags               = module.tags.tags
}

########################################
# Example module invocation
########################################
module "example" {
  source = "../.."

  cluster_name      = aws_ecs_cluster.example.name
  container_port    = 80
  container_image   = "docker.io/library/nginx:latest"
  load_balancer_arn = aws_lb.public.arn
  listener_port     = 80
  name              = module.tags.name
  subnets           = var.subnets
  tags              = module.tags.tags
  vpc_id            = var.vpc_id
}

output "dns_name" {
  description = "DNS name of ALB"
  value       = aws_lb.public.dns_name
}
