data "aws_route53_zone" "main" {
  zone_id = var.hosted_zone_id
}

resource "aws_route53_record" "root-a" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_root.domain_name
    zone_id                = aws_cloudfront_distribution.s3_root.hosted_zone_id
    evaluate_target_health = false
  }
}
