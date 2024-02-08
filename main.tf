locals {
  bucket_name = var.domain_name
}

locals {
  common_tags = {
    created_by     = "TechieInYou"
  }
}
