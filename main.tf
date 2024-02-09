locals {
  bucket_name = var.domain_name
}

data "aws_caller_identity" "current" {}

