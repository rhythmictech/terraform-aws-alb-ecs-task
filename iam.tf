########################################
# I is for IAM, and this module creates two roles
#
# ECS Task Execution Role, IAM role used by the task itself
#   e.g. if your container wants to call other AWS services like S3, SQS, etc
#   then those permissions would need to be covered by the TaskRole
########################################
data "aws_iam_policy_document" "assume" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      identifiers = ["ecs-tasks.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "ecs_task" {
  name_prefix        = local.ecs_task_iam_role_name_prefix
  assume_role_policy = data.aws_iam_policy_document.assume.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "additional" {
  count = length(var.additional_ecs_task_policy_arns)

  policy_arn = var.additional_ecs_task_policy_arns[count.index]
  role       = aws_iam_role.ecs_task.id
}

########################################
# ECS Execution Role
#   IAM role that executes ECS actions such as pulling the image and storing the application logs in cloudwatch
#   https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task_execution_IAM_role.html
########################################
resource "aws_iam_role" "ecs_exec" {
  name_prefix        = local.ecs_exec_iam_role_name_prefix
  assume_role_policy = data.aws_iam_policy_document.ecs_exec.json
  tags               = var.tags
}

data "aws_iam_policy_document" "ecs_exec" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_exec" {
  role       = aws_iam_role.ecs_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_exec_additional" {
  count = length(var.additional_ecs_service_exec_policy_arns)

  policy_arn = var.additional_ecs_service_exec_policy_arns[count.index]
  role       = aws_iam_role.ecs_exec.id
}
