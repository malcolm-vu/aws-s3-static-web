terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    random = {
      source = "hashicorp/random"
      version = "~> 3.6"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "s3" {
    source = "./modules/s3"
    cloudfront_oac_id = module.cloudfront.origin_access_control
}

module "cloudfront" {
    source = "./modules/cloudfront"
    s3_bucket_domain_name = module.s3.reg_domain_name
    origin_id = "s3-static-website"
}