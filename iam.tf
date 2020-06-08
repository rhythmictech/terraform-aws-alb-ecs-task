########################################
# I is for IAM, and this module creates two roles
#
# ECS Task Execution Role
#   IAM role used by the task itself
#    e.g. if your container wants to call other AWS services like S3, SQS, etc
#    then those permissions would need to be covered by the TaskRole
########################################
data "aws_iam_policy_document" "assume" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task" {
  name_prefix        = "${var.name}-ecs-task-"
  assume_role_policy = data.aws_iam_policy_document.assume.json
  tags               = var.tags
}

resource "aws_iam_role_policy" "additional" {
  count = length(var.additional_ecs_task_policy_arns)

  name_prefix = "${var.name}-ecs-task-policy-${count.index}"
  policy      = var.additional_ecs_task_policy_arns[count.index]
  role        = aws_iam_role.ecs_task.id
}

########################################
# ECS Execution Role
#   IAM role that executes ECS actions such as pulling the image and storing the application logs in cloudwatch
########################################
resource "aws_iam_role" "ecs_exec" {
  name_prefix        = "${var.name}-ecs-exec-"
  assume_role_policy = data.aws_iam_policy_document.assume.json
  tags               = var.tags
}

data "aws_iam_policy_document" "ecs_exec" {
  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "ssm:GetParameters",
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
  }
}

resource "aws_iam_role_policy" "ecs_exec" {
  name_prefix = "${var.name}-ecs-exec-"
  policy      = data.aws_iam_policy_document.ecs_exec.json
  role        = aws_iam_role.ecs_exec.id
}
