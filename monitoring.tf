provider "site24x7" {
  oauth2_client_id = "<SITE24X7_CLIENT_ID>"
  oauth2_client_secret = "<SITE24X7_CLIENT_SECRET>"
  oauth2_refresh_token = "<SITE24X7_REFRESH_TOKEN>"
  oauth2_access_token = "<SITE24X7_OAUTH2_ACCESS_TOKEN>"
  access_token_expiry = "0"
  #zaaid = "1234"
  data_center = "US"
  retry_min_wait = 1
  retry_max_wait = 30
  max_retries = 4
}

resource "site24x7_website_monitor" "hello_world_lambda" {
  display_name = "hello_world_lambda"
  website = aws_api_gateway_deployment.LambdaApiGatewayDeployment.invoke_url
  check_frequency = "50"
  location_profile_name = "North America"
}

resource "site24x7_website_monitor" "hello_world_bucket" {
  display_name = "hello_world_bucket"
  website = aws_s3_bucket.hello_world_bucket.website_endpoint
  check_frequency = "50"
  location_profile_name = "North America"
}

resource "site24x7_website_monitor" "hello_world_ec2" {
  display_name = "hello_world_ec2"
  website = aws_instance.hello_world_ec2_instance.public_dns
  check_frequency = var.monitoring.check_frequency
  location_profile_name = var.monitoring.location_profile_name
}