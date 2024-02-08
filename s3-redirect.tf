# S3 bucket for redirecting non-www to www.
resource "aws_s3_bucket" "web_portal_redirect" {
  count  = (var.need_www_redirect) ? 1 : 0
  bucket = "www.${local.bucket_name}"
  tags   = local.common_tags
}

resource "aws_s3_bucket_ownership_controls" "web_portal_redirect_acl_ownership" {
  count  = (var.need_www_redirect) ? 1 : 0
  bucket = aws_s3_bucket.web_portal_redirect[0].id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_public_access_block" "web_portal_redirect" {
  count                   = (var.need_www_redirect) ? 1 : 0
  bucket                  = aws_s3_bucket.web_portal_redirect[0].id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "web_portal_redirect_acl" {
  count      = (var.need_www_redirect) ? 1 : 0
  bucket     = aws_s3_bucket.web_portal_redirect[0].id
  acl        = "public-read"
  depends_on = [aws_s3_bucket_ownership_controls.web_portal_redirect_acl_ownership]
}

resource "aws_s3_bucket_policy" "web_portal_redirect_policy" {
  count      = (var.need_www_redirect) ? 1 : 0
  bucket     = aws_s3_bucket.web_portal_redirect[0].id
  policy     = templatefile("templates/www-s3-policy.json", { bucket = "www.${var.domain_name}" })
  depends_on = [aws_s3_bucket_ownership_controls.web_portal_redirect_acl_ownership]
}

resource "aws_s3_bucket_website_configuration" "web_portal_redirect_config" {
  count  = (var.need_www_redirect) ? 1 : 0
  bucket = aws_s3_bucket.web_portal_redirect[0].id
  redirect_all_requests_to {
    host_name = "https://${var.domain_name}"
  }
}
