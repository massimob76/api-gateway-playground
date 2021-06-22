resource "aws_cloudwatch_log_group" "echo_query_param" {
  name              = "/aws/lambda/${local.lambda_function_name}"
  retention_in_days = 1
}