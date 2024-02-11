terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.36.0"
      configuration_aliases = [aws.us-east-1, aws]
    }
  }
}

locals {
  bucket_name = lower(var.domain_name)
  origin_access = lower(var.s3_access_method)
}

data "aws_caller_identity" "current" {}

