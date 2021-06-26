output "full_url" {
  value = "${aws_api_gateway_deployment.echo_query_param.invoke_url}${aws_api_gateway_resource.echo_query_param.path}"
}