# Static website hosted via Amazon S3
This repository contains Terraform code for deploying a sample static website hosted on Amazon S3 and distributed via Amazon CloudFront. The infrastructure is structured using Terraform modules to enhance modularity and reusability. Key components of the setup include:

## Modules:
- S3 Module: Manages the static website hosting on S3, including bucket configuration and access policies.
- CloudFront Module: Configures the CloudFront distribution, including cache settings and distribution policies.
- Logging Module: Sets up S3 buckets for logging CloudFront access and server access logs, with appropriate IAM policies and bucket policies to handle log delivery.

## Origin Access Control (OAC):
Utilizes CloudFront Origin Access Control (OAC) to securely restrict direct access to the S3 bucket, ensuring that only CloudFront can access the content. This enhances security by preventing unauthorized access.

## Logging Configuration:
Implements logging for both CloudFront and S3 server access logs. This setup includes policies for log delivery and storage, enabling monitoring and analysis of access patterns and errors.

This approach leverages Terraform’s modular architecture to separate concerns, promote reuse, and streamline management of the infrastructure components.
