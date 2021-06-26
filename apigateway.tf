resource "aws_api_gateway_rest_api" "echo_query_param" {
  name        = "EchoQueryParam"
}

resource "aws_api_gateway_resource" "echo_query_param" {
  rest_api_id = aws_api_gateway_rest_api.echo_query_param.id
  parent_id   = aws_api_gateway_rest_api.echo_query_param.root_resource_id
  path_part   = "echo"
}

resource "aws_api_gateway_method" "echo_query_param" {
  rest_api_id   = aws_api_gateway_rest_api.echo_query_param.id
  resource_id   = aws_api_gateway_resource.echo_query_param.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "echo_query_param_200" {
  rest_api_id = aws_api_gateway_rest_api.echo_query_param.id
  resource_id = aws_api_gateway_resource.echo_query_param.id
  http_method = aws_api_gateway_method.echo_query_param.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration" "echo_query_param_lambda" {
  rest_api_id = aws_api_gateway_rest_api.echo_query_param.id
  resource_id = aws_api_gateway_method.echo_query_param.resource_id
  http_method = aws_api_gateway_method.echo_query_param.http_method

  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = aws_lambda_function.echo_query_param.invoke_arn

  request_templates = {
    "application/json" = file("templates/api_gateway_body_mapping.template")
  }
}

resource "aws_api_gateway_integration_response" "echo_query_param_lambda" {
  rest_api_id = aws_api_gateway_rest_api.echo_query_param.id
  resource_id = aws_api_gateway_resource.echo_query_param.id
  http_method = aws_api_gateway_method.echo_query_param.http_method
  status_code = aws_api_gateway_method_response.echo_query_param_200.status_code
}

resource "aws_api_gateway_deployment" "echo_query_param" {
  rest_api_id = aws_api_gateway_rest_api.echo_query_param.id
  stage_name  = "live"
  depends_on = [ aws_api_gateway_integration.echo_query_param_lambda ]
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.echo_query_param.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.echo_query_param.execution_arn}/*/${aws_api_gateway_method.echo_query_param.http_method}${aws_api_gateway_resource.echo_query_param.path}"
}

