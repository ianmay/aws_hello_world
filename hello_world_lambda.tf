# create a policy to be used by the role for our lambda
data "aws_iam_policy_document" "AWSLambdaTrustPolicy" {
  statement {
    actions    = ["sts:AssumeRole"]
    effect     = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# create the for the lambda
resource "aws_iam_role" "hello_world_lambda_role" {
  name               = "hello_world_lambda_role"
  assume_role_policy = "${data.aws_iam_policy_document.AWSLambdaTrustPolicy.json}"
}

# create an archive of the hello world code to deploy
data "archive_file" "hello_world_lambda_archive" {
  type        = "zip"
  source_file = "${var.hello_world_lambda.local_path}"
  output_path = "${var.hello_world_lambda.name}.zip"
}

# create the lambda from the archive file
resource "aws_lambda_function" "hello_world_lambda" {
  function_name    = "${var.hello_world_lambda.name}"
  runtime          = "${var.hello_world_lambda.runtime}"
  handler          = "${var.hello_world_lambda.handler}"
  filename         = "${data.archive_file.hello_world_lambda_archive.output_path}"
  source_code_hash = "${data.archive_file.hello_world_lambda_archive.output_base64sha256}"
  role      	     = "${aws_iam_role.hello_world_lambda_role.arn}"
}

# create an API Gateway to allow us to access the lambda. This will be the container for all other gateway objects.
resource "aws_api_gateway_rest_api" "LambdaApiGateway" {
  name        = "LambdaApiGateway"
}

# path_part value "{proxy+}" activates proxy behavior sp that we match any request path. 
resource "aws_api_gateway_resource" "LambdaApiGatewayProxy" {
   rest_api_id = aws_api_gateway_rest_api.LambdaApiGateway.id
   parent_id   = aws_api_gateway_rest_api.LambdaApiGateway.root_resource_id
   path_part   = "{proxy+}"
}

# http_method of "ANY", which allows any request method to be used. 
resource "aws_api_gateway_method" "LambdaApiGatewayProxyMethod" {
   rest_api_id   = aws_api_gateway_rest_api.LambdaApiGateway.id
   resource_id   = aws_api_gateway_resource.LambdaApiGatewayProxy.id
   http_method   = "ANY"
   authorization = "NONE"
}

resource "aws_api_gateway_method" "LambdaApiGatewayProxyMethodRoot" {
   rest_api_id   = aws_api_gateway_rest_api.LambdaApiGateway.id
   resource_id   = aws_api_gateway_rest_api.LambdaApiGateway.root_resource_id
   http_method   = "ANY"
   authorization = "NONE"
}

# route incoming requests to the lambda 
resource "aws_api_gateway_integration" "LambdaApiGatewayIntegration" {
   rest_api_id             = aws_api_gateway_rest_api.LambdaApiGateway.id
   resource_id             = aws_api_gateway_method.LambdaApiGatewayProxyMethod.resource_id
   http_method             = aws_api_gateway_method.LambdaApiGatewayProxyMethod.http_method
   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.hello_world_lambda.invoke_arn
}

resource "aws_api_gateway_integration" "LambdaApiGatewayIntegrationRoot" {
   rest_api_id             = aws_api_gateway_rest_api.LambdaApiGateway.id
   resource_id             = aws_api_gateway_method.LambdaApiGatewayProxyMethodRoot.resource_id
   http_method             = aws_api_gateway_method.LambdaApiGatewayProxyMethodRoot.http_method
   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.hello_world_lambda.invoke_arn
}

# allow gateway to invoke the lambda
resource "aws_lambda_permission" "LambdaApiGatewayPermission" {
   statement_id  = "AllowLambdaAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.hello_world_lambda.function_name
   principal     = "apigateway.amazonaws.com"
   source_arn    = "${aws_api_gateway_rest_api.LambdaApiGateway.execution_arn}/*/*/*"
}

# expose the API and config at a URL for testing 
resource "aws_api_gateway_deployment" "LambdaApiGatewayDeployment" {
   depends_on = [
     aws_api_gateway_integration.LambdaApiGatewayIntegration,
     aws_api_gateway_integration.LambdaApiGatewayIntegrationRoot,
   ]
   rest_api_id = aws_api_gateway_rest_api.LambdaApiGateway.id
   stage_name  = var.api_deployment_stage_name
}

# output the url for testing
output "hello_world_lambda_url" {
  value = aws_api_gateway_deployment.LambdaApiGatewayDeployment.invoke_url
}
