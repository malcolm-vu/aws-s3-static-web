output "website_url" {
    description = "Domain name of CloudFront distribution"
    value = "https://${module.cloudfront.cloudfront_domain_name}"
}

output "bucket_name" {
    description = "Name of the S3 bucket"
    value = module.s3.bucket_name
}