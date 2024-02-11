data "aws_route53_zone" "main" {
  zone_id = var.hosted_zone_id
}

resource "aws_route53_record" "root-a" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = (local.origin_access == "public") ? aws_cloudfront_distribution.public[0].domain_name : (local.origin_access == "oac") ? aws_cloudfront_distribution.oac[0].domain_name : aws_cloudfront_distribution.oai[0].domain_name
    zone_id                = (local.origin_access == "public") ? aws_cloudfront_distribution.public[0].hosted_zone_id : (local.origin_access == "oac") ? aws_cloudfront_distribution.oac[0].hosted_zone_id : aws_cloudfront_distribution.oai[0].hosted_zone_id
    evaluate_target_health = false
  }
}
