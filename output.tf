output "cdn_url" {
  value = (local.origin_access == "public") ? aws_cloudfront_distribution.public[0].domain_name : (local.origin_access == "oac") ? aws_cloudfront_distribution.oac[0].domain_name : aws_cloudfront_distribution.oai[0].domain_name
}

output "website_url" {
  value = "https://${var.domain_name}"
}
