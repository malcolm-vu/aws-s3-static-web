# Define S3 bucket to store logs 
resource "aws_s3_bucket" "log_bucket" {
  bucket = "s3-logs-${random_string.bucket_suffix.result}"
}

# Creates random suffix for bucket to ensure name is globally unique
resource "random_string" "bucket_suffix" {
  length = 8
  special = false
  upper = false
}

# Create S3 bucket ACL required for Cloudfront logs to access the log bucket
resource "aws_s3_bucket_acl" "log_bucket_acl" {
  bucket = aws_s3_bucket.log_bucket.id

  access_control_policy {
    owner {
      id = data.aws_canonical_user_id.current.id
    }

    grant {
      grantee {
        id = data.aws_canonical_user_id.current.id
        type = "CanonicalUser"
      }
      permission = "FULL_CONTROL"
    }
    
    grant {
      # Grant Cloudfront logs access to S3 bucket
      # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/AccessLogs.html#AccessLogsBucketAndFileOwnership
      grantee {
        id = "c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0" # this is not unique (same for everyone)
        type = "CanonicalUser"
      }
      permission = "FULL_CONTROL"
    }
  }
}

# Define IAM policy document for S3 server access logging
data "aws_iam_policy_document" "s3_logging_policy" {
  statement {
    sid    = "AllowS3ServerAccessLogsPolicy"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["logging.s3.amazonaws.com"]
    }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.log_bucket.arn}/s3-access-logs/*"]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = [var.src_bucket_arn]
    }
  }
}

# Define IAM policy document for CloudFront logging
data "aws_iam_policy_document" "cloudfront_logging_policy" {
  statement {
    sid    = "AllowCloudFrontLogsPolicy"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.log_bucket.arn}/cloudfront-logs/*"]
    condition {
      test     = "StringEquals"
      variable = "s3:x-amz-acl"
      values   = ["bucket-owner-full-control"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}

# Combine the two policy documents
data "aws_iam_policy_document" "combined_logging_policy" {
  source_policy_documents = [
    data.aws_iam_policy_document.s3_logging_policy.json,
    data.aws_iam_policy_document.cloudfront_logging_policy.json,
  ]
}

# Attach the combined policy to the logs bucket
resource "aws_s3_bucket_policy" "logs_bucket_policy" {
  bucket = aws_s3_bucket.log_bucket.id
  policy = data.aws_iam_policy_document.combined_logging_policy.json
}

# Data source to get the current AWS account ID
data "aws_caller_identity" "current" {}

# Data source to get canonical ID of AWS account
data "aws_canonical_user_id" "current" {}

# Enable S3 server access logging for the static web S3 bucket
resource "aws_s3_bucket_logging" "website_logging" {
    bucket = var.src_bucket_id
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "s3-access-logs/"
}

# CloudWatch Alarm for CloudFront errors
resource "aws_cloudwatch_metric_alarm" "http_4xx_errors" {
  alarm_name          = "HTTP 4xx Errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "4xxErrorRate"
  namespace           = "AWS/CloudFront"
  period              = 60
  statistic           = "Average"
  threshold           = 1

  dimensions = {
    DistributionId = var.cloudfront_distribution_id
    Region = "Global"
  }

  alarm_description = "Alarm if 4xx error rate exceeds 1%"
  alarm_actions     = [aws_sns_topic.alerts.arn]
}

# IAM role for CloudWatch
resource "aws_iam_role" "cloudwatch_role" {
  name = "cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "cloudwatch.amazonaws.com"
        }
      }
    ]
  })
}

# Define IAM policy document for CloudWatch
data "aws_iam_policy_document" "cloudwatch_policy" {
  statement {
    effect = "Allow"
    actions = [
      "cloudwatch:GetMetricStatistics",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:GetDashboard",
      "cloudwatch:ListMetrics"
    ]
    resources = [var.cloudfront_distribution_arn]
  }
}

# Create IAM policy for CloudWatch
resource "aws_iam_policy" "cloudwatch_policy" {
  name        = "cloudwatch-policy"
  description = "IAM policy for CloudWatch"
  policy      = data.aws_iam_policy_document.cloudwatch_policy.json
}

# Attach the CloudWatch policy to the role
resource "aws_iam_role_policy_attachment" "cloudwatch_policy_attachment" {
  policy_arn = aws_iam_policy.cloudwatch_policy.arn
  role       = aws_iam_role.cloudwatch_role.name
}

# SNS Topic for sending alerts
resource "aws_sns_topic" "alerts" {
  name = var.sns_topic_name
}

# SNS Subscription for email notifications
resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.notification_email
}
