output "logging_bucket_id" {
    description = "ID of the logging bucket"
    value = aws_s3_bucket.log_bucket.id 
}

