variable "index_document" {
  description = "The index document for the static website"
  type        = string
  default     = "index.html"
}

variable "error_document" {
  description = "The error document for the static website"
  type        = string
  default     = "error.html"
}

variable "cloudfront_distribution_arn" {
  description = "CloudFront ARN"
  type = string
}