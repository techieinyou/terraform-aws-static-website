locals {
  mime_types = {
    "css"  = "text/css"
    "html" = "text/html"
    "ico"  = "image/vnd.microsoft.icon"
    "js"   = "application/javascript"
    "json" = "application/json"
    "map"  = "application/json"
    "png"  = "image/png"
    "jpg"  = "image/jpg"
    "svg"  = "image/svg+xml"
    "txt"  = "text/plain"
  }
}

resource "aws_s3_bucket" "web_portal" {
  bucket = local.bucket_name
  tags   = var.tags
}

data "aws_iam_policy_document" "root_public_access" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    effect = "Allow"

    actions = [
      "s3:GetObject"
    ]

    resources = [
      aws_s3_bucket.web_portal.arn,
      "${aws_s3_bucket.web_portal.arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [format("arn:aws:cloudfront::%s:distribution/%s", data.aws_caller_identity.current.account_id, aws_cloudfront_origin_access_control.oac.id)]
    }
  }
}

resource "aws_s3_bucket_cors_configuration" "web_portal_cors" {
  bucket = aws_s3_bucket.web_portal.id

  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["https://${var.domain_name}"]
    max_age_seconds = 3000
  }
}

resource "aws_s3_bucket_ownership_controls" "web_portal_acl_ownership" {
  bucket = aws_s3_bucket.web_portal.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# to turn off Block public access (bucket settings)
resource "aws_s3_bucket_public_access_block" "web_portal" {
  bucket                  = aws_s3_bucket.web_portal.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "web_portal_acl" {
  bucket     = aws_s3_bucket.web_portal.id
  acl        = "public-read"
  depends_on = [aws_s3_bucket_ownership_controls.web_portal_acl_ownership]
}

resource "aws_s3_bucket_policy" "web_portal_policy" {
  bucket = aws_s3_bucket.web_portal.id
  policy     = data.aws_iam_policy_document.root_public_access.json
  depends_on = [aws_s3_bucket_acl.web_portal_acl]
}

resource "aws_s3_bucket_website_configuration" "web_portal_webConfig" {
  bucket = aws_s3_bucket.web_portal.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_object" "index_html" {
  count = (var.need_placeholder_website) ? 1 : 0

  depends_on   = [aws_s3_bucket.web_portal]
  bucket       = local.bucket_name
  key          = "index.html"
  source       = "./website/index.html"
  content_type = "text/html"
}

resource "aws_s3_object" "error_html" {
  count = (var.need_placeholder_website) ? 1 : 0

  depends_on   = [aws_s3_bucket.web_portal]
  bucket       = local.bucket_name
  key          = "error.html"
  source       = "./website/error.html"
  content_type = "text/html"
}

