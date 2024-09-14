
variable "src_bucket_id" {
    description = "Name of S3 bucket to enable logging for"
    type = string
}

variable "src_bucket_arn" {
    description = "ARN of the S3 bucket to enable logging for"
    type = string
}

variable "cloudfront_distribution_id" {
    description = "ID of the Cloudfront distribution"
    type = string
}

variable "cloudfront_distribution_arn" {
    description = "ARN of the Cloudfront distribution"
    type = string
}

variable "sns_topic_name" {
    description = "Name of SNS topic"
    type = string
}

variable "notification_email" {
    description = "Email for SNS to send notifications to"
    type = string
}