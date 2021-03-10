#Event rule to direct events to the Lambda Function
resource "aws_cloudwatch_event_rule" "event" {
  name        = var.name
  description = "Schedule to trigger lambda function"
  schedule_expression = var.schedule_expression
}

#Target to direct event at function
resource "aws_cloudwatch_event_target" "function_target" {
  rule = aws_cloudwatch_event_rule.event.name
  target_id = var.name
  arn = aws_lambda_function.function.arn
}

#Permission to allow event trigger
resource "aws_lambda_permission" "allow_cloudwatch_event_trigger" {
  statement_id = "TrustCWEToInvokeMyLambdaFunction"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.function.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.event.arn
}

#Automatic packaging of code
data "archive_file" "function_code" {
  type = "zip"
  source_dir = "${path.module}/rq_worker_restart.js"
  output_path = "${path.module}/function_code.zip"
}

#Function to process event
resource "aws_lambda_function" "function" {
  filename = data.archive_file.function_code.output_path
  source_code_hash = filebase64sha256(data.archive_file.function_code.output_path)
  function_name = var.name
  role = aws_iam_role.function_role.arn
  handler = "rq_work_restart.handler"
  runtime = "nodejs12.x"
  timeout = var.timeout_sec
  memory_size = var.memory_size
  environment {
    variables = {
      SERVICE_NAME = var.service_name
      CLUSTER_NAME = var.cluster_name
      FORCE_NEW_DEPLOYMENT = var.force_new_deployment
    }
  }
 #Should we include VPC/Security Group info..
  lifecycle {
    ignore_changes = [last_modified]
  }
  tags = var.input_tags

}

#Role to attach policy to Function
resource "aws_iam_role" "function_role" {
  name = var.name
  tags = var.input_tags

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}

#Default policy for Lambda to be executed and put logs in Cloudwatch
resource "aws_iam_role_policy" "function_policy_default" {
  name = "${var.name}-default-policy"
  role = aws_iam_role.function_role.id

policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowListCloudWatchLogGroups",
      "Effect": "Allow",
      "Action": "logs:DescribeLogStreams",
      "Resource": "arn:aws:logs:${data.aws_region.current.name}:*:*"
    },
    {
      "Sid": "AllowCreatePutLogGroupsStreams",
      "Effect": "Allow",
      "Action": [
          "logs:PutLogEvents",
          "logs:CreateLogStream",
          "logs:CreateLogGroup"
      ],
      "Resource": [
          "arn:aws:logs:${data.aws_region.current.name}:*:log-group:/aws/lambda/${var.name}",
          "arn:aws:logs:${data.aws_region.current.name}:*:log-group:/aws/lambda/${var.name}:log-stream:*"
      ]
    },
    {
      "Sid": "AllowEcsUpdateService",
      "Effect": "Allow",
      "Action": "ecs:",
      "Resource":[
        "arn:aws:ecs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:service/${var.service_name}"
        "arn:aws:ecs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:service/${var.cluster_name}/${var.service_name}"
        ]
    },
  ]
}
EOF

}

#Policy for additional Permissions for Lambda Execution
resource "aws_iam_role_policy" "function_policy" {
  name = var.name
  role = aws_iam_role.function_role.id

policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowListCloudWatchLogGroups",
      "Effect": "Allow",
      "Action": "logs:Describe*",
      "Resource": "arn:aws:logs:${data.aws_region.current.name}:*:*"
    },
    {
      "Sid": "AllowCreatePutLogGroupsStreams",
      "Effect": "Allow",
      "Action": [
          "logs:PutLogEvents",
          "logs:CreateLogStream",
          "logs:CreateLogGroup",
          "logs:GetLogEvents"
      ],
      "Resource": [
          "${var.target_log_group}",
          "${var.target_log_group}:log-stream:*"
      ]
    },

  ]
}
EOF
}

#Cloudwatch Log Group for Function
resource "aws_cloudwatch_log_group" "log_group" {
  name = "/aws/lambda/${aws_lambda_function.function.function_name}"

  retention_in_days = var.cloudwatch_log_retention_days

  tags = var.input_tags
}
