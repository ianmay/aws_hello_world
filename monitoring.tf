provider "site24x7" {
  oauth2_client_id      = var.monitoring.oauth2_client_id
  oauth2_client_secret  = var.monitoring.oauth2_client_secret
  oauth2_refresh_token  = var.monitoring.oauth2_refresh_token
  oauth2_access_token   = var.monitoring.oauth2_access_token
  data_center = "US"
  retry_min_wait = 1
  retry_max_wait = 30
  max_retries = 4
}

resource "site24x7_threshold_profile" "website_threshold_profile_us" {
  profile_name = "URL Threshold Profile - Terraform"
  type = "URL"

  website_content_changes {
    severity     = 3
    value = 95
  }

  primary_response_time_critical_threshold = {
    severity = 3
    comparison_operator = 1
    value               = 2000
    strategy            = 2
    polls_check         = 5
  }

  secondary_response_time_trouble_threshold = {
    severity = 2
    comparison_operator = 1
    value               = 3000
    strategy            = 2
    polls_check         = 5
  }

  secondary_response_time_critical_threshold = {
    severity = 3
    comparison_operator = 1
    value               = 4000
    strategy            = 2
    polls_check         = 5
  }
}

resource "site24x7_website_monitor" "hello_world_lambda" {
  depends_on = [
     aws_api_gateway_deployment.LambdaApiGatewayDeployment,
     site24x7_threshold_profile.website_threshold_profile_us
  ]
  display_name = "hello_world_lambda"
  website = aws_api_gateway_deployment.LambdaApiGatewayDeployment.invoke_url
  check_frequency = var.monitoring.check_frequency
  location_profile_name = "North America"
}

resource "site24x7_website_monitor" "hello_world_bucket" {
  depends_on = [
     aws_s3_bucket.hello_world_bucket,
     site24x7_threshold_profile.website_threshold_profile_us
  ]  
  display_name = "hello_world_bucket"
  website = "http://${aws_s3_bucket.hello_world_bucket.website_endpoint}"
  check_frequency = var.monitoring.check_frequency
  location_profile_name = "North America"
}

resource "site24x7_website_monitor" "hello_world_ec2" {
  depends_on = [
     aws_s3_bucket.hello_world_bucket,
     aws_instance.hello_world_ec2_instance
  ]   
  display_name = "hello_world_ec2"
  website = "http://${aws_instance.hello_world_ec2_instance.public_dns}"
  check_frequency = var.monitoring.check_frequency
  location_profile_name = var.monitoring.location_profile_name
}


#1000.cd057adeaa3f4e8369b1f2227613ac37.f4e60a7ba807b45cc1dcb38100f5e58a


# curl.exe https://accounts.zoho.com/oauth/v2/token -X POST -d "client_id=1000.XXXXX" -d "client_secret=xxxx" -d "code=1000.XXXXX.XXXXXX" -d "grant_type=authorization_code" --insecure
 # {"access_token":"1000.d12c3e52053f353a8a9418538e508cdf.fb3a6fdc92714289149f890d69785b9e","refresh_token":"1000.06e00d00f19a5cf4905010ebcf0fc7a5.71917f0aa605e3ec57ac31a6d619b135","api_domain":"https://www.zohoapis.com","token_type":"Bearer","expires_in":3600}