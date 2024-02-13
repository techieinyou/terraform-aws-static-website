output "cloudfront_id" {
  value       = (local.origin_access == "public") ? aws_cloudfront_distribution.public[0].id : (local.origin_access == "oac") ? aws_cloudfront_distribution.oac[0].id : aws_cloudfront_distribution.oai[0].id
  description = "Id of CloudFront created for the Static Website"
}

output "cloudfront_url" {
  value       = format("https://%s", (local.origin_access == "public") ? aws_cloudfront_distribution.public[0].domain_name : (local.origin_access == "oac") ? aws_cloudfront_distribution.oac[0].domain_name : aws_cloudfront_distribution.oai[0].domain_name)
  description = "URL of CloudFront created for the Static Website"
}

output "website_url" {
  value       = "https://${var.domain_name}"
  description = "URL of the Static Website"
}
