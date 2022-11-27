provider "aws" {
  # variables will be stored in a seprate file called variables.tf
  region = var.aws_region
  # this makes things faster!
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}

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
  source_file = "${var.hello_world_app.local_path}"
  output_path = "${var.hello_world_app.name}.zip"
}

# create the lambda from the archive file
resource "aws_lambda_function" "hello_world_lambda" {
  function_name    = "${var.hello_world_app.name}"
  runtime          = "${var.hello_world_app.runtime}"
  handler          = "${var.hello_world_app.handler}"
  filename         = "${data.archive_file.hello_world_lambda_archive.output_path}"
  source_code_hash = "${data.archive_file.hello_world_lambda_archive.output_base64sha256}"
  role      	     = "${aws_iam_role.hello_world_lambda_role.arn}"
}

