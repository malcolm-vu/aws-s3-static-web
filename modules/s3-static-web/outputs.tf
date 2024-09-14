output "website_bucket_id" {
  description = "ID of the static web bucket"
  value = aws_s3_bucket.static_web_bucket.id
}

output "website_bucket_arn" {
  description = "ARN of the static website"
  value = aws_s3_bucket.static_web_bucket.arn
}

output "reg_domain_name" {
  description = "Domain name of the web bucket"
  value = aws_s3_bucket.static_web_bucket.bucket_regional_domain_name
}