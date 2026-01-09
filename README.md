# AWS Infrastructure

Foundational AWS account-level infrastructure managed as code using Terraform. This repository provisions the core resources required for secure, automated deployments and state management across your AWS environment.

## Overview

This infrastructure establishes the foundational components needed to support other AWS projects and deployments:

- **Terraform State Management**: S3 backend with DynamoDB locking for safe, concurrent operations
- **GitHub Actions Integration**: OIDC provider and IAM roles for secure, keyless CI/CD deployments
- **API Gateway Configuration**: Account-level settings and custom domain setup
- **CloudWatch Logging**: IAM roles for API Gateway logging

## Features

### Terraform Backend
- S3 bucket with versioning, encryption, and lifecycle policies
- DynamoDB table for state locking
- Public access blocking and private ACLs

### GitHub Actions OIDC
- OpenID Connect provider for GitHub
- IAM role with trust policy for GitHub Actions workflows
- Eliminates need for long-lived AWS credentials

### API Gateway
- Account-level CloudWatch logging configuration
- Custom domain name support
- Centralized API management

## Prerequisites

- Terraform >= 1.0
- AWS CLI configured with appropriate credentials
- AWS account with administrative access
- GitHub repository (for OIDC integration)

## Usage

### Initial Setup

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd aws-infrastructure
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Review the planned changes:
   ```bash
   terraform plan
   ```

4. Apply the infrastructure:
   ```bash
   terraform apply
   ```

### Using the GitHub Actions Role

After deployment, configure your GitHub Actions workflows to use the OIDC role:

```yaml
permissions:
  id-token: write
  contents: read

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: aws-actions/configure-aws-credentials@v4
        with:
          role-to-assume: ${{ secrets.AWS_ROLE_ARN }}
          aws-region: us-east-1
```

### Configuring Terraform Backend

Other projects can use the created S3 backend:

```hcl
terraform {
  backend "s3" {
    bucket         = "<your-state-bucket>"
    key            = "<project>/terraform.tfstate"
    region         = "<your-region>"
    dynamodb_table = "<your-lock-table>"
    encrypt        = true
  }
}
```

## Security

- All S3 buckets use server-side encryption (SSE)
- Public access is blocked on state buckets
- IAM roles follow least-privilege principles
- OIDC eliminates static credentials in CI/CD

## Maintenance

- State files are versioned for recovery
- Lifecycle policies manage old versions
- Regular updates to provider versions recommended

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.26.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_api_gateway_account.api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_account) | resource |
| [aws_api_gateway_domain_name.api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_domain_name) | resource |
| [aws_dynamodb_table.state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/dynamodb_table) | resource |
| [aws_iam_openid_connect_provider.github](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.github_actions_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.github_actions_terraform_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_route53_record.api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.primary](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |
| [aws_s3_bucket.bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_lifecycle_configuration.backend_lifecycle](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_public_access_block.notpublic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.backend_sse](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.backend_versioning](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_iam_openid_connect_provider.github_actions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_openid_connect_provider) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_github_actions_role_arn"></a> [github\_actions\_role\_arn](#output\_github\_actions\_role\_arn) | ARN of the IAM role for foundational GitHub Actions |
<!-- END_TF_DOCS -->