output "bucket_name" {
  value = aws_s3_bucket.static_web_bucket.id
}

output "website_url" {
  value = aws_s3_bucket_website_configuration.static_web_config.website_endpoint
}

output "reg_domain_name" {
  value = aws_s3_bucket.static_web_bucket.bucket_regional_domain_name
}