# Define the S3 bucket
resource "aws_s3_bucket" "static_web_bucket" {
  bucket = "static-website-${random_string.bucket_suffix.result}"

}

# Configure the S3 bucket for static website hosting
resource "aws_s3_bucket_website_configuration" "static_web_config" {
  bucket = aws_s3_bucket.static_web_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# Upload index.html
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.static_web_bucket.id
  key = "index.html"
  source = "website/index.html"
}

# Upload error.html
resource "aws_s3_object" "error_html" {
  bucket = aws_s3_bucket.static_web_bucket.id
  key = "error.html"
  source = "website/error.html"
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.static_web_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Define IAM policy document 
data "aws_iam_policy_document" "s3_access" {
  statement {
    actions = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.static_web_bucket.arn}/*"]
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = ["${var.cloudfront_oac_id}"]
    }
  }
}

# Attach policy to S3 bucket
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.static_web_bucket.id
  policy = data.aws_iam_policy_document.s3_access.json
}

# Set bucket ownership controls
resource "aws_s3_bucket_ownership_controls" "ownership_controls" {
  bucket = aws_s3_bucket.static_web_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "random_string" "bucket_suffix" {
  length = 8
  special = false
  upper = false
}