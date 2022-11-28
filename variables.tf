# basic variable!
variable "aws_region" {
 type        = string
 default     = "ap-southeast-2"
}

variable "monthly_budget_amount" {
 type        = string
 default     = "10"
}

# you can create objects too! 
variable "hello_world_app" {
 type = object({
    name       = string
    local_path = string
    handler    = string
    runtime    = string
  })
  default = {
    name       = "hello_world"
    local_path = "./hello_world/hello_world/app.py"
    handler    = "app.lambda_handler"
    runtime    = "python3.9"
  }
}

# stage name for our deployment (for api gateway)
variable "api_deployment_stage_name" {
 type        = string
 default     = "test"
}