# cloudfront OAC for accessing s3 content
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = var.domain_name
  description                       = "Origin Access Control for ${var.domain_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# cloudfront OAI for accessing s3 content
resource "aws_cloudfront_origin_access_identity" "oai" {
  comment = "OAI to access ${local.bucket_name}"
}

# Cloudfront for primary(root) S3
resource "aws_cloudfront_distribution" "s3_root" {

  origin {
    domain_name = (local.bucket_access_method == "public") ? aws_s3_bucket_website_configuration.web_portal_webConfig.website_endpoint : aws_s3_bucket.web_portal.bucket_domain_name
    origin_id                = "S3-${local.bucket_name}"
    origin_access_control_id = (local.bucket_access_method == "oac") ? aws_cloudfront_origin_access_control.oac.id : null
    s3_origin_config {
      origin_access_identity = (local.bucket_access_method == "oai") ? aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path:null
    }

    # custom_origin_config {
    #   http_port              = 80
    #   https_port             = 443
    #   origin_protocol_policy = "http-only"
    #   origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    # }
  }

  enabled         = true
  is_ipv6_enabled = true

  # aliases = [var.domain_name]
  aliases = (var.need_www_redirect) ? [var.domain_name, "www.${var.domain_name}"] : [var.domain_name]

  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
  }

  custom_error_response {
    error_caching_min_ttl = 10
    error_code            = 403
    response_code         = 200
    response_page_path    = "/index.html"
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${local.bucket_name}"

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }

      headers = ["Origin"]
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.ssl.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  tags = var.tags
}
