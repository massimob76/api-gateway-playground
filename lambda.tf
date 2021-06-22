resource "null_resource" "lambda_build" {

  triggers = {
    main = join("", [
    for file in fileset(local.lambda_source_dir, "*.go") : filebase64("${local.lambda_source_dir}/${file}")
    ])
  }

  provisioner "local-exec" {
    command = "export GO111MODULE=on"
  }

  provisioner "local-exec" {
    command = "GOOS=linux go build -ldflags '-s -w' -o ${local.lambda_bin_path} ${local.lambda_source_dir}/."
  }
}

data "archive_file" "echo_query_param" {
  type             = "zip"
  source_file      = local.lambda_bin_path
  output_file_mode = "0666"
  output_path      = local.lambda_zip_path

  depends_on = [null_resource.lambda_build]
}

resource "aws_lambda_function" "echo_query_param" {
  filename      = data.archive_file.echo_query_param.output_path
  function_name = local.lambda_function_name
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "HandleRequest"
  source_code_hash = data.archive_file.echo_query_param.output_base64sha256
  runtime = "go1.x"

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.echo_query_param,
  ]
}