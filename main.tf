module "s3-static-web" {
    source = "./modules/s3-static-web"
    cloudfront_distribution_arn = module.cloudfront.cloudfront_distribution_arn
}

module "cloudfront" {
    source = "./modules/cloudfront"
    s3_bucket_domain_name = module.s3-static-web.reg_domain_name
    origin_id = "s3-static-website"
    logging_bucket_id = module.logging.logging_bucket_id
}

module "logging" {
  source = "./modules/logging"
  src_bucket_arn = module.s3-static-web.website_bucket_arn
  src_bucket_id = module.s3-static-web.website_bucket_id
  cloudfront_distribution_id = module.cloudfront.cloudfront_id
  cloudfront_distribution_arn = module.cloudfront.cloudfront_distribution_arn
  sns_topic_name = "s3-static-web-alerts"
  notification_email = "<your-email-address>"
}