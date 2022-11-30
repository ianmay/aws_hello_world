terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.19"
    }
    site24x7 = {
      source  = "site24x7/site24x7"
      version = "~> 1.0.0"
    }
  }
}