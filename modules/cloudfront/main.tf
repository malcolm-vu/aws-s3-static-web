resource "aws_cloudfront_distribution" "cloudfront" {
  origin {
    domain_name = var.s3_bucket_domain_name
    origin_id   = var.origin_id 
    origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront_oac.id
  }

  enabled = true

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.origin_id

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = "CloudFront Distribution"
  }
}

resource "aws_cloudfront_origin_access_control" "cloudfront_oac" {
  name                              = "cloudfront-oac"
  description                       = "OAC for S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}