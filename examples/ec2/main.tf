########################################
# Data Sources
########################################
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

########################################
# Tags and Naming
########################################
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

  names = [
    data.aws_caller_identity.current.account_id,
    data.aws_region.current.name,
    local.name
  ]

  tags = merge({
    "Env"       = local.env,
    "Namespace" = local.namespace,
    "Owner"     = local.owner
  }, local.extra_tags)
}

########################################=
#  ECS and ALB
########################################=
resource "tls_private_key" "ecs_root" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

module "ecs_cluster" {
  # source  = "rhythmictech/ecs_cluster/aws"
  # version = "1.1.0"
  source = "github.com/rhythmictech/terraform-aws-ecs-cluster?ref=cleanup"

  name              = module.tags.name
  tags              = module.tags.tags
  vpc_id            = data.aws_vpc.default.id
  alb_subnet_ids    = data.aws_subnet_ids.default.ids
  ssh_pubkey        = tls_private_key.ecs_root.public_key_openssh
  instance_type     = "t3.micro"
  region            = data.aws_region.current.name
  min_instances     = 1
  max_instances     = 2
  desired_instances = 1
}

resource "aws_security_group_rule" "allow_all_http_ingress" {
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:AWS006
  description       = "Allow everything to access our example"
  from_port         = 80
  protocol          = "-1"
  security_group_id = module.ecs_cluster.alb_sg_id
  to_port           = 80
  type              = "ingress"
}

resource "aws_security_group_rule" "allow_all_egress" {
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:AWS007
  description       = "Allow our example to egress anywhere"
  from_port         = 0
  protocol          = "-1"
  security_group_id = module.ecs_cluster.alb_sg_id
  to_port           = 0
  type              = "egress"
}

########################################
# Example module invocation
########################################
module "example" {
  source = "../.."

  alb_security_group_id = module.ecs_cluster.alb_sg_id
  cluster_name          = module.ecs_cluster.cluster_name
  container_port        = 80
  container_image       = "docker.io/library/nginx:alpine"
  load_balancer_arn     = module.ecs_cluster.alb_arn
  listener_port         = 80
  name                  = module.tags.name
  subnets               = data.aws_subnet_ids.default.ids
  tags                  = module.tags.tags
  vpc_id                = data.aws_vpc.default.id
}

output "dns_name" {
  description = "DNS name of ALB"
  value       = module.ecs_cluster.alb_dns_name
}
