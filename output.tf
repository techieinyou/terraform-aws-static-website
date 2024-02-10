output "cdn_url" {
  value = "https://${aws_cloudfront_distribution.s3_root.domain_name}" 
}

output "website_url" {
  value = "https://${var.domain_name}"
}