output "origin_access_control" {
    value = aws_cloudfront_origin_access_control.cloudfront_oac.id
}

output "cloudfront_domain_name" {
    description = "Domain name of CloudFront distribution"
    value = aws_cloudfront_distribution.cloudfront.domain_name
}