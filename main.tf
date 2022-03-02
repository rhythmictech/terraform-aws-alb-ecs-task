########################################
# Security Groups for ECS service
########################################
resource "aws_security_group" "ecs_service" {
  name_prefix = var.name
  description = "Security Group for ECS Service ${var.name}"
  tags        = var.tags
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "allow_all_egress" {
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:AWS007
  description       = "Allow all traffic to egress from ${var.name}"
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.ecs_service.id
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "alb" {
  description              = "Allow ALB traffic in to ECS service ${var.name}"
  from_port                = var.container_port
  protocol                 = "tcp"
  security_group_id        = aws_security_group.ecs_service.id
  source_security_group_id = var.alb_security_group_id
  to_port                  = var.container_port
  type                     = "ingress"
}

########################################
# Logs
########################################
resource "aws_cloudwatch_log_group" "this" {
  name = "/aws/ecs/${var.name}"
  tags = var.tags
}

########################################
# LB
########################################
resource "aws_lb_target_group" "this" {
  name_prefix = local.lb_target_group_name_prefix
  port        = var.target_group_port
  protocol    = var.internal_protocol
  tags        = var.tags
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    healthy_threshold   = var.health_check.healthy_threshold
    interval            = var.health_check.interval
    path                = var.health_check.path
    port                = var.health_check.port
    protocol            = var.health_check.protocol
    unhealthy_threshold = var.health_check.unhealthy_threshold
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener_rule" "this" {
  listener_arn = var.listener_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.id
  }

  #TODO: use dynamic block to create different conditions
  condition {
    host_header {
      values = [var.host_header]
    }
  }
}

########################################
# ECS
########################################
module "container_definition" {
  source  = "cloudposse/ecs-container-definition/aws"
  version = "0.58.1"

  environment       = var.environment_variables
  container_cpu     = var.task_cpu
  container_image   = var.container_image
  container_memory  = var.task_memory
  container_name    = local.container_name
  log_configuration = local.log_configuration
  port_mappings     = local.port_mappings
  secrets           = var.secrets
}

resource "aws_ecs_task_definition" "this" {
  container_definitions    = module.container_definition.json_map_encoded_list
  cpu                      = var.task_cpu
  execution_role_arn       = try(aws_iam_role.ecs_exec[0].arn, var.ecs_execution_role)
  family                   = var.name
  memory                   = var.task_memory
  network_mode             = var.network_mode
  requires_compatibilities = [var.launch_type]
  tags                     = var.tags
  task_role_arn            = try(aws_iam_role.ecs_task[0].arn, var.ecs_task_role)

  lifecycle {
    ignore_changes = [container_definitions]
  }
}

resource "aws_ecs_service" "this" {
  cluster         = var.cluster_name
  desired_count   = var.task_desired_count
  launch_type     = var.launch_type
  name            = var.name
  task_definition = aws_ecs_task_definition.this.arn

  load_balancer {
    container_name   = local.container_name
    container_port   = var.container_port
    target_group_arn = aws_lb_target_group.this.arn
  }

  lifecycle {
    # Subsequent deploys are likely to be done through an external deployment pipeline
    #  so if this is rerun without ignoring the task def change
    #  then terraform will roll it back :(
    ignore_changes = [task_definition]
  }

  network_configuration {
    assign_public_ip = var.assign_ecs_service_public_ip
    security_groups  = compact(concat(var.security_group_ids, [aws_security_group.ecs_service.id]))
    subnets          = var.subnets
  }
}
