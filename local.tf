locals {
  lambda_function_name  = "echo-query-param"
  lambda_path           = "${path.module}/lambda"
  lambda_exec_name      = "echoQueryParam"
  lambda_source_dir     = "${local.lambda_path}/cmd/${local.lambda_exec_name}"
  lambda_bin_path       = "${local.lambda_path}/bin/${local.lambda_exec_name}"
  lambda_zip_path       = "${local.lambda_path}/archive/echoQueryParam.zip"
}
