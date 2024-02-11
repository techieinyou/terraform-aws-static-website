resource "aws_acm_certificate" "ssl" {
  domain_name               = var.domain_name
  validation_method         = "DNS"
  subject_alternative_names = (var.need_www_redirect) ? ["www.${var.domain_name}"] : []

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}
