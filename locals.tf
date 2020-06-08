########################################
# Locals
########################################
locals {
  cloudwatch_log_group_name_prefix = "/ecs/${var.name}-"
  container_name                   = coalesce(var.container_name, "api-${var.name}")
  # cannot be longer than 32 chars
  ecs_exec_iam_role_name_prefix = "${substr(var.name, 0, 22)}-ecs-exec-"
  ecs_task_iam_role_name_prefix = "${substr(var.name, 0, 22)}-ecs-task-"
  # cannot be longer than 6 chars
  lb_target_group_name_prefix = "${substr(var.name, 0, 2)}-tg-"

  log_configuration = {
    logDriver : "awslogs",
    options = {
      "awslogs-group" : aws_cloudwatch_log_group.this.name,
      "awslogs-region" : "${var.region}",
      "awslogs-stream-prefix" : "ecs"
    }
    secretOptions = []
  }

  port_mappings = [
    {
      containerPort = var.container_port
      hostPort      = var.container_port
      protocol      = "tcp"
    },
  ]
}
