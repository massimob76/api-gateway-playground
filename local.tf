locals {
  lambda_function_name  = "echo-query-param"
  lambda_path           = "${path.module}/lambda"
  lambda_source_dir     = "${local.lambda_path}/cmd/echoQueryParam"
  lambda_bin_path       = "${local.lambda_path}/bin/echoQueryParam"
  lambda_zip_path       = "${local.lambda_path}/archive/echoQueryParam.zip"
}
