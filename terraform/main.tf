terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
    
    backend "s3" {
        bucket = "seanezell-terraform-backend"
        key = "terraformbacked/terraform.tfstate"
        region = "us-west-2"
        dynamodb_table = "terraform_state"
    }
}

/*
    Backend S3 bucket
*/
resource "aws_s3_bucket" "bucket" {
    bucket = "seanezell-terraform-backend"
    tags = {
        Name = "Terraform Backend"
        Env = "foundation"
    }
}

resource "aws_s3_bucket_acl" "private" {
    bucket = aws_s3_bucket.bucket.id
    acl = "private"
}

resource "aws_s3_bucket_public_access_block" "notpublic" {
    bucket = aws_s3_bucket.bucket.id
    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}

/* Enable versioning so prior states are retained */
resource "aws_s3_bucket_versioning" "backend_versioning" {
    bucket = aws_s3_bucket.bucket.id

    versioning_configuration {
        status = "Enabled"
    }
}

/* Server-side encryption for state at rest */
resource "aws_s3_bucket_server_side_encryption_configuration" "backend_sse" {
    bucket = aws_s3_bucket.bucket.id

    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
}

resource "aws_s3_bucket_lifecycle_configuration" "backend_lifecycle" {
    bucket = aws_s3_bucket.bucket.id

    rule {
        id     = "state-prune"
        status = "Enabled"

        filter {}

        noncurrent_version_expiration {
            noncurrent_days = 90
        }

        expiration {
            days = 3650
        }
    }
}

/*
    DynamoDB table for state locking
*/
resource "aws_dynamodb_table" "state" {
    name = "terraform_state"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"
    attribute {
        name = "LockID"
        type = "S"
    }
    tags = {
        "Name" = "DynamoDB Terraform State Lock Table"
    }
}

/*
    API Gateway Domain and CloudWatch Role
*/
resource "aws_iam_role" "cloudwatch" {
    name = "api_gateway_cloudwatch_global"

    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "apigateway.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy" "cloudwatch" {
    name = "api-gateway-cloudwatch-policy"
    role = aws_iam_role.cloudwatch.id

    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:PutLogEvents",
                "logs:GetLogEvents",
                "logs:FilterLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

provider "aws" {
    alias  = "useast1"
    region = "us-east-1"
}

resource "aws_api_gateway_domain_name" "api" {
    certificate_arn = "arn:aws:acm:us-east-1:736813861381:certificate/b225eb43-6514-478d-a42f-5c4d229f5bf1"
    domain_name     = "api.seanezell.com"
    security_policy = "TLS_1_2"
}

resource "aws_api_gateway_account" "api" {
    cloudwatch_role_arn = aws_iam_role.cloudwatch.arn
}

/*
    GitHub Actions OIDC provider (account-wide)
*/
resource "aws_iam_openid_connect_provider" "github" {
    url = "https://token.actions.githubusercontent.com"
    client_id_list = ["sts.amazonaws.com"]

    thumbprint_list = [
        "6938fd4d98bab03faadb97b34396831e3780aea1",
        "1c58a3a8518e8759bf075b76b750d4f2df264fcd"
    ]
}

resource "aws_route53_zone" "primary" {
    name = "seanezell.com"
}

# api records
resource "aws_route53_record" "api" {
    zone_id = aws_route53_zone.primary.zone_id
    name    = "api"
    type    = "CNAME"
    ttl     = 300
    records = ["djl4zqy00azhv.cloudfront.net"]
}