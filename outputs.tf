########################################
# outputs
########################################
output "cloudwatch_log_group" {
  description = "aws_cloudwatch_log_group resource"
  value       = aws_cloudwatch_log_group.this
}

output "lb_target_group" {
  description = "aws_lb_target_group resource"
  value       = aws_lb_target_group.this
}

output "ecs_service" {
  description = "aws_ecs_service resource"
  value       = aws_ecs_service.this
}

output "iam_role_ecs_service" {
  description = "aws_iam_role resource for the ECS service"
  value       = aws_iam_role.ecs_exec
}

output "ecs_task_iam_role" {
  description = "aws_iam_role resource for the ECS task"
  value       = aws_iam_role.ecs_task
}

output "security_group" {
  description = "aws_security_group resource for the ECS service"
  value       = aws_security_group.ecs_service
}

output "task_definition" {
  description = "aws_ecs_task_definition resource"
  value       = aws_ecs_task_definition.this
}
