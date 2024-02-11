# S3 bucket for redirecting www.domain to domain
resource "aws_s3_bucket" "web_portal_redirect" {
  count  = (var.need_www_redirect) ? 1 : 0
  bucket = "www.${local.bucket_name}"
  tags   = var.tags
}

resource "aws_s3_bucket_ownership_controls" "web_portal_redirect_acl_ownership" {
  count  = (var.need_www_redirect) ? 1 : 0
  bucket = aws_s3_bucket.web_portal_redirect[0].id
  rule {
    object_ownership = "BucketOwnerPreferred"
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
  policy     = (local.origin_access == "oac") ? data.aws_iam_policy_document.www_access_oac[0].json : (local.origin_access == "oai") ? data.aws_iam_policy_document.www_access_oai[0].json : data.aws_iam_policy_document.www_access_public[0].json
  depends_on = [aws_s3_bucket_ownership_controls.web_portal_redirect_acl_ownership]
}

resource "aws_s3_bucket_website_configuration" "web_portal_redirect_config" {
  count  = (var.need_www_redirect) ? 1 : 0
  bucket = aws_s3_bucket.web_portal_redirect[0].id
  redirect_all_requests_to {
    host_name = "https://${var.domain_name}"
  }
}
