########################################
# Locals
########################################
locals {
  cloudwatch_log_group_name = coalesce(var.cloudwatch_log_group_name, "/ecs/${var.name}")
  container_name            = coalesce(var.container_name, "api-${var.name}")

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
