provider "aws" {
  # variables will be stored in a seprate file called variables.tf
  region = var.aws_region
  # this makes things faster!
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = false
}

# this will stand up :
# * hello_world_lambda.tf : a hello world lambda and gpi gateway
# * hello_world_bucket.tf : static hello world page via a s3 bucket
# * hello_world_ec2ins.tf : a linux ec2 instance hosting a hello world page

# variables are held in variables.tf
# budget is managed in budget.tf
