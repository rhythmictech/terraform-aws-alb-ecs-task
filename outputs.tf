########################################
# outputs
########################################

output "cloudwatch_log_group" {
  description = "aws_cloudwatch_log_group resource"
  value       = aws_cloudwatch_log_group.this
}

output "ecs_service" {
  description = "aws_ecs_service resource"
  value       = aws_ecs_service.this
}

output "ecs_task_iam_role" {
  description = "aws_iam_role resource for the ECS task"
  value       = aws_iam_role.ecs_task
}

output "iam_role_ecs_service" {
  description = "aws_iam_role resource for the ECS service"
  value       = aws_iam_role.ecs_exec
}

output "lb_target_group" {
  description = "aws_lb_target_group resource"
  value       = aws_lb_target_group.this
}

output "security_group_id" {
  description = "Resource ID ofr Security Group associated with ECS Service network_configuration"
  value       = aws_security_group.ecs_service.id
}

output "task_definition" {
  description = "aws_ecs_task_definition resource"
  value       = aws_ecs_task_definition.this
}
