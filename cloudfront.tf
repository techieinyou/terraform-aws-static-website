# cloudfront OAC for accessing s3 content
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = var.domain_name
  description                       = "Origin Access Control for ${var.domain_name}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Cloudfront for primary(root) S3
resource "aws_cloudfront_distribution" "s3_root" {

  origin {
    # domain_name = aws_s3_bucket_website_configuration.web_portal_webConfig.website_endpoint
    domain_name = aws_s3_bucket.web_portal.bucket_domain_name
    origin_id   = "S3-${local.bucket_name}"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
    # s3_origin_config {
    #   origin_access_identity = aws_cloudfront_origin_access_identity.user.cloudfront_access_identity_path
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
