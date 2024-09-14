output "website_url" {
    description = "Domain name of CloudFront distribution"
    value = "https://${module.cloudfront.cloudfront_domain_name}"
}

output "cloudfront_id" {
    description = "ID of CloudFront distribution"
    value = module.cloudfront.cloudfront_id
}

output "website-bucket" {
    description = "Name of the static web S3 bucket"
    value = module.s3-static-web.website_bucket_id
}

output "log-bucket" {
    description = "Name of the log S3 bucket"
    value = module.logging.logging_bucket_id
}