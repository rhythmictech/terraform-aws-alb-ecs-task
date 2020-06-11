########################################
# Variables
########################################

variable "alb_security_group_id" {}
variable "cluster_name" {}
variable "load_balancer_arn" {}
variable "subnet_ids" {}
variable "vpc_id" {}

########################################
# Data Sources
########################################
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

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

########################################
# Example module invocation
########################################
module "example" {
  source = "../.."

  alb_security_group_id = var.alb_security_group_id
  cluster_name          = var.cluster_name
  container_port        = 80
  container_image       = "docker.io/library/nginx:alpine"
  load_balancer_arn     = var.load_balancer_arn
  listener_port         = 80
  name                  = module.tags.name
  subnets               = var.subnet_ids
  tags                  = module.tags.tags
  vpc_id                = var.vpc_id
}
