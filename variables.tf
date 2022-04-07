########################################
# Variables
########################################

variable "additional_ecs_task_policy_arns" {
  default     = []
  description = "ARNs for additional ECS task policies"
  type        = list(string)
}

variable "additional_ecs_service_exec_policy_arns" {
  default     = []
  description = "ARNs for additional ECS Service Execution Role policies"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "ID for ALB Security Group"
  type        = string
}

variable "assign_ecs_service_public_ip" {
  default     = false
  description = "Assigns a public IP to your ECS service. Set true if using fargate, see https://aws.amazon.com/premiumsupport/knowledge-center/ecs-pull-container-api-error-ecr/"
  type        = bool
}

variable "cluster_name" {
  description = "Name of ECS cluster"
  type        = string
}

variable "container_image" {
  default     = "busybox"
  description = "Container image, ie 203583890406.dkr.ecr.us-west-1.amazonaws.com/api-integrations:git-34752db"
  type        = string
}

variable "container_name" {
  default     = null
  description = "Defaults to `api-<var.name>`"
  type        = string
}

variable "container_port" {
  description = "Port on Container that main process is listening on"
  type        = number
}

variable "environment_variables" {
  default     = null
  description = "The environment variables to pass to the container. This is a list of maps"
  type = list(object({
    name  = string
    value = string
  }))
}

variable "health_check" {
  default = {
    healthy_threshold   = 3
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    unhealthy_threshold = 3
  }
  description = <<EOD
Target group health check, for LB to assess service health
See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group#health_check
EOD
  type = object({
    healthy_threshold   = number
    interval            = number
    path                = string
    port                = string
    protocol            = string
    unhealthy_threshold = number
  })
}

variable "host_header" {
  type        = string
  description = <<EOF
The hostname in the request which acts as condition for listener. See
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule#host_header
EOF
}

variable "internal_protocol" {
  default     = "HTTP"
  description = "Protocol for traffic between the ALB and ECS. Should be one of [TCP, TLS, UDP, TCP_UDP, HTTP, HTTPS]"
  type        = string
}

variable "launch_type" {
  default     = "FARGATE"
  description = "ECS service launch type: FARGATE | EC2"
  type        = string
}

variable "listener_arn" {
  description = "ARN of listener on ALB"
  type        = string
}

variable "name" {
  description = "Moniker to apply to all resources in module"
  type        = string
}

variable "network_mode" {
  default     = "awsvpc"
  description = "The Docker networking mode to use for the containers in the task. The valid values are none, bridge, awsvpc, and host."
  type        = string
}

variable "secrets" {
  default     = null
  description = "The secrets to pass to the container. This is a list of maps"
  type = list(object({
    name      = string
    valueFrom = string
  }))
}

variable "security_group_ids" {
  default     = []
  description = "List of Security Group IDs to apply to the ECS Service"
  type        = list(string)
}

variable "service_registry_arn" {
  default     = null
  description = "ARN of aws_service_discovery_service"
  type        = string
}

variable "subnets" {
  default     = []
  description = "Subnets that should be added to ECS service network configuration"
  type        = list(string)
}

variable "tags" {
  default     = {}
  description = "Resource Tags. BE VERBOSE. Should AT MINIMIUM contain; Name & Owner"
  type        = map(string)
}

variable "target_group_port" {
  default     = 80
  description = "The port on which targets receive traffic on the Target Group"
  type        = number
}

variable "task_cpu" {
  default     = 1024
  description = "The number of cpu units used by the task."
  type        = number
}

variable "task_desired_count" {
  default     = 1
  description = "Number of copies of task definition that should be running at any given time"
  type        = number
}

variable "task_memory" {
  default     = 2048
  description = "The amount (in MiB) of memory used by the task."
  type        = number
}

variable "vpc_id" {
  description = "VPC ID where resources will be created"
  type        = string
}

variable "ecs_task_role" {
  default     = ""
  description = "ECS task execution role. If specified none will be created"
  type        = string
}

variable "ecs_execution_role" {
  default     = ""
  description = "ECS execution role. If specified none will be created"
  type        = string
}

########################################
# Data
########################################
data "aws_region" "current" {}
