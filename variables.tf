variable "domain_name" {
  type        = string
  description = "Domain for the Static Website eg. mywebsite.com"
}

variable "hosted_zone_id" {
  type        = string
  description = "Id of the Hosted Zone in Route 53"
}

variable "need_www_redirect" {
  type        = string
  default     = false
  description = "Whether redirect from wwww required or not. If yes, this module will create 2 sites with domain_name.com and www.domain_name.com"
}
