variable "s3_bucket_domain_name" {
    description = "The domain name of the S3 bucket"
    type = string 
}

variable "origin_id" {
    description = "Unique identifier for the CloudFront origin"
    type = string
}

variable "logging_bucket_id" {
    description = "Name of the S3 bucket that stores the logs"
    type = string
}