locals {
  bucket_name = lower(var.domain_name)
  origin_access = lower(var.s3_access_method)
}

data "aws_caller_identity" "current" {}

