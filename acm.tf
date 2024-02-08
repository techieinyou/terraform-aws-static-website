resource "aws_acm_certificate" "ssl" {
  provider                  = aws.acm_provider
  domain_name               = var.domain_name
  validation_method         = "DNS"
  subject_alternative_names = (var.need_www_redirect) ? ["www.${var.domain_name}"] : []

  tags = local.common_tags

  lifecycle {
    create_before_destroy = true
  }
}
