locals {
  bucket_name = lower(var.domain_name)
  bucket_access_method = lower(var.s3_access_method)
}

data "aws_caller_identity" "current" {}

