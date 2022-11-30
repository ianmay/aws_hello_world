# basic variable!
variable "aws_region" {
 type        = string
 default     = "ap-southeast-2"
}

# you can create objects too! 
variable "hello_world_lambda" {
 type = object({
    name       = string
    local_path = string
    handler    = string
    runtime    = string
  })
  default = {
    name       = "hello_world"
    local_path = "./hello_world_lambda/hello_world/app.py"
    handler    = "app.lambda_handler"
    runtime    = "python3.9"
  }
}

variable "hello_world_bucket" {
 type = object({
    path       = string
    domain     = string
  })
  default = {
    path       = "./hello_world_static/index.html"
    domain     = "ianmay-aws-hello-world"
  }
}

# stage name for our deployment (for api gateway)
variable "api_deployment_stage_name" {
 type        = string
 default     = "test"
}

# variables to hold our budget details
variable "budget" {
 type = object({
    amount     = string
    email      = list(string)
    time_span  = string
  })
  default = {
    amount     = "10"
    email      = ["not@really.real"]
    time_span  = "MONTHLY"
  }
}

# variables to hold our site 24x7 monitoring details
variable "monitoring"{ 
 type = object({
    check_frequency        = string
    location_profile_name  = string
    oauth2_client_id       = string
    oauth2_client_secret   = string
    oauth2_refresh_token   = string
    oauth2_access_token    = string

  })
  default = {
    check_frequency        = "5"
    location_profile_name  = "North America"
    oauth2_client_id       = "1000.FILLMEIN"
    oauth2_client_secret   = "FILLMEIN"
    oauth2_refresh_token   = "1000.FILLMEIN.FILLMEIN"
    oauth2_access_token    = "1000.FILLMEIN.FILLMEIN"
    
  }
}