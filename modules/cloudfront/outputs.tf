output "cloudfront_distribution_arn" {
    description = "ARN of CloudFront distribution"
    value = aws_cloudfront_distribution.cloudfront.arn
}

output "cloudfront_id" {
    description = "ID of CloudFront distribution"
    value = aws_cloudfront_distribution.cloudfront.id
}

output "cloudfront_domain_name" {
    description = "Website URL"
    value = aws_cloudfront_distribution.cloudfront.domain_name
}