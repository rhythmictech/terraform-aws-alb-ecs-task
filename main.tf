########################################
# S is for Security Groups
########################################
resource "aws_security_group" "ecs_service" {
  description = "Allow ALL egress from ECS service"
  name        = "${var.name}-sg"
  tags        = var.tags
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "allow_all_egress" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.ecs_service.id
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "allow_icmp_ingress" {
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 8
  protocol          = "icmp"
  security_group_id = aws_security_group.ecs_service.id
  to_port           = 0
  type              = "ingress"
}

resource "aws_security_group_rule" "custom_rules" {
  count             = length(var.custom_security_group_rules)
  cidr_blocks       = var.custom_security_group_rules[count.index].cidr_blocks
  from_port         = var.custom_security_group_rules[count.index].from_port
  protocol          = var.custom_security_group_rules[count.index].protocol
  security_group_id = aws_security_group.ecs_service.id
  type              = var.custom_security_group_rules[count.index].type
  to_port           = var.custom_security_group_rules[count.index].to_port
}

# do we have to whitelist the private subnets?
# resource "aws_security_group_rule" "nlb" {
#   type              = "ingress"
#   from_port         = var.container_port
#   to_port           = var.container_port
#   protocol          = "tcp"
#   cidr_blocks       = var.nlb_cidr_blocks
#   security_group_id = aws_security_group.ecs_service.id
# }

########################################
# L is for logging and load balancing
########################################
resource "aws_cloudwatch_log_group" "this" {
  name_prefix = "${local.cloudwatch_log_group_name}-"
  tags        = var.tags
}

resource "aws_lb_target_group" "this" {
  name_prefix = module.tags.name32
  port        = var.target_group_port
  protocol    = "HTTP"
  tags        = var.tags
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    healthy_threshold   = var.health_check.healthy_threshold
    interval            = var.health_check.interval
    port                = var.health_check.port
    protocol            = var.health_check.protocol
    unhealthy_threshold = var.health_check.unhealthy_threshold
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "this" {
  depends_on        = [aws_lb_target_group.this]
  load_balancer_arn = var.load_balancer_arn
  port              = var.listener_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.this.arn
    type             = "forward"
  }
}

########################################
# E is for elastic container task definition
#  and elastic container service
########################################
module "container_definition" {
  source = "github.com/cloudposse/terraform-aws-ecs-container-definition?ref=0.25.0"

  environment       = local.environment
  container_cpu     = var.task_cpu
  container_image   = local.container_image
  container_memory  = var.task_memory
  container_name    = local.container_name
  log_configuration = local.log_configuration
  port_mappings     = local.port_mappings
}

resource "aws_ecs_task_definition" "this" {
  container_definitions    = module.container_definition.json
  cpu                      = var.task_cpu
  execution_role_arn       = aws_iam_role.ecs_exec.arn
  family                   = "${var.name}-task-def"
  memory                   = var.task_memory
  network_mode             = var.network_mode
  requires_compatibilities = [var.launch_type]
  tags                     = var.tags
  task_role_arn            = aws_iam_role.ecs_task.arn
}

resource "aws_ecs_service" "this" {
  cluster         = var.cluster_name
  desired_count   = var.task_desired_count
  launch_type     = var.launch_type
  name_prefix     = "${module.tags.name}-"
  task_definition = aws_ecs_task_definition.this.arn

  load_balancer {
    container_name   = local.container_name
    container_port   = var.container_port
    target_group_arn = aws_lb_target_group.this.arn
  }

  lifecycle {
    # Subsequent deploys are done via code pipeline
    #  so if this is rerun without ignoring the task def change
    #  then terraform will roll it back :(
    ignore_changes = [task_definition]
  }

  network_configuration {
    # set assign_public_ip = true when using FARGATE, see
    # https://aws.amazon.com/premiumsupport/knowledge-center/ecs-pull-container-api-error-ecr/
    assign_public_ip = (var.launch_type == "FARGATE")
    security_groups  = compact(concat(var.security_groups, [aws_security_group.ecs_service.id]))
    subnets          = var.subnets
  }
}
