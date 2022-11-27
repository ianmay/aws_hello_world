# basic variable!
variable "aws_region" {
 type        = string
 default     = "ap-southeast-2"
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
    handler    = "main.lambda_handler"
    runtime    = "python3.9"
  }
}
 
