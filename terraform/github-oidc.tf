locals {
  policy_aws_infrastructure = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*",
          "dynamodb:*",
          "cognito-idp:*",
          "iam:*",
          "sts:GetCallerIdentity",
          "sts:AssumeRoleWithWebIdentity",
          "apigateway:*",
          "route53:*",
          "cloudfront:*"
        ]
        Resource = "*"
      }
    ]
  })

  policy_what2play_infrastructure = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:CreateBucket",
          "s3:DeleteBucket",
          "s3:GetBucketPolicy",
          "s3:PutBucketPolicy",
          "s3:DeleteBucketPolicy",
          "s3:GetBucketPublicAccessBlock",
          "s3:PutBucketPublicAccessBlock",
          "s3:GetBucketTagging",
          "s3:PutBucketTagging",
          "s3:GetBucketAcl",
          "s3:GetBucketCORS",
          "s3:GetBucketWebsite",
          "s3:GetBucketVersioning",
          "s3:GetBucketObjectLockConfiguration",
          "s3:GetBucketRequestPayment",
          "s3:GetBucketLogging",
          "s3:GetAccelerateConfiguration",
          "s3:GetLifecycleConfiguration",
          "s3:GetReplicationConfiguration",
          "s3:GetEncryptionConfiguration",
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "cloudfront:CreateDistribution",
          "cloudfront:DeleteDistribution",
          "cloudfront:GetDistribution",
          "cloudfront:UpdateDistribution",
          "cloudfront:TagResource",
          "cloudfront:ListTagsForResource",
          "cloudfront:CreateOriginAccessControl",
          "cloudfront:DeleteOriginAccessControl",
          "cloudfront:GetOriginAccessControl",
          "cloudfront:UpdateOriginAccessControl",
          "cloudfront:GetCachePolicy",
          "cloudfront:ListCachePolicies"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "acm:DescribeCertificate",
          "acm:GetCertificate",
          "acm:ListCertificates",
          "acm:ListTagsForCertificate"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "cognito-idp:CreateUserPool",
          "cognito-idp:DeleteUserPool",
          "cognito-idp:DescribeUserPool",
          "cognito-idp:UpdateUserPool",
          "cognito-idp:CreateUserPoolClient",
          "cognito-idp:DeleteUserPoolClient",
          "cognito-idp:DescribeUserPoolClient",
          "cognito-idp:UpdateUserPoolClient",
          "cognito-idp:CreateUserPoolDomain",
          "cognito-idp:DeleteUserPoolDomain",
          "cognito-idp:DescribeUserPoolDomain",
          "cognito-idp:SetUserPoolMfaConfig",
          "cognito-idp:GetUserPoolMfaConfig"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "iam:CreateRole",
          "iam:DeleteRole",
          "iam:GetRole",
          "iam:PassRole",
          "iam:PutRolePolicy",
          "iam:DeleteRolePolicy",
          "iam:GetRolePolicy",
          "iam:ListRolePolicies",
          "iam:ListAttachedRolePolicies",
          "iam:TagRole",
          "iam:UntagRole",
          "iam:GetOpenIDConnectProvider",
          "iam:ListOpenIDConnectProviders"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "lambda:CreateFunction",
          "lambda:DeleteFunction",
          "lambda:GetFunction",
          "lambda:UpdateFunctionCode",
          "lambda:UpdateFunctionConfiguration",
          "lambda:AddPermission",
          "lambda:RemovePermission",
          "lambda:GetPolicy",
          "lambda:ListVersionsByFunction",
          "lambda:PublishVersion",
          "lambda:TagResource",
          "lambda:GetFunctionCodeSigningConfig",
          "lambda:ListTags",
          "lambda:GetFunctionConfiguration"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:DeleteLogGroup",
          "logs:DescribeLogGroups",
          "logs:PutRetentionPolicy",
          "logs:ListTagsLogGroup",
          "logs:ListTagsForResource",
          "logs:TagResource"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "route53:GetHostedZone",
          "route53:ListHostedZones",
          "route53:ChangeResourceRecordSets",
          "route53:GetChange",
          "route53:ListResourceRecordSets"
        ]
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ]
        Resource = "arn:aws:dynamodb:us-west-2:*:table/terraform_state"
      },
      {
        Effect   = "Allow"
        Action   = ["sts:GetCallerIdentity"]
        Resource = "*"
      }
    ]
  })

  policy_what2play_services = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "apigateway:*",
          "lambda:*",
          "logs:*",
          "cloudwatch:*",
          "dynamodb:*",
          "secretsmanager:*",
          "iam:*",
          "ec2:*",
          "s3:*",
          "cognito-idp:*",
          "kms:*"
        ]
        Resource = "*"
      }
    ]
  })

  policy_website_infrastructure = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*",
          "dynamodb:*",
          "cognito-idp:*",
          "iam:*",
          "sts:GetCallerIdentity",
          "acm:*",
          "cloudfront:*",
          "route53:*"
        ]
        Resource = "*"
      }
    ]
  })
}

module "aws_infrastructure_oidc" {
  source = "./modules/github_oidc_repo_role"

  oidc_provider_arn = aws_iam_openid_connect_provider.github.arn
  role_name         = "aws_githubaction_role"
  policy_name       = "aws_githubaction_policy"
  subjects          = ["repo:seanezell/aws-infrastructure:ref:refs/heads/main"]
  policy_json       = local.policy_aws_infrastructure
}

module "what2play_infrastructure_oidc" {
  source = "./modules/github_oidc_repo_role"

  oidc_provider_arn = aws_iam_openid_connect_provider.github.arn
  role_name         = "what2play_githubaction_role"
  policy_name       = "what2play_githubaction_policy"
  subjects          = ["repo:seanezell/what2play-*:ref:refs/heads/*"]
  policy_json       = local.policy_what2play_infrastructure
}

module "what2play_services_oidc" {
  source = "./modules/github_oidc_repo_role"

  oidc_provider_arn = aws_iam_openid_connect_provider.github.arn
  role_name         = "what2play-services_githubaction_role"
  policy_name       = "what2play-services_githubaction_policy"
  subjects          = ["repo:seanezell/what2play-*:ref:refs/heads/main"]
  policy_json       = local.policy_what2play_services
}

module "website_infrastructure_oidc" {
  source = "./modules/github_oidc_repo_role"

  oidc_provider_arn = aws_iam_openid_connect_provider.github.arn
  role_name         = "website_infra_githubaction_role"
  policy_name       = "website_infra_githubaction_policy"
  subjects          = ["repo:seanezell/website-infrastructure:ref:refs/heads/main"]
  policy_json       = local.policy_website_infrastructure
}

module "what2play_client_deploy_oidc" {
  source = "./modules/github_oidc_repo_role"
  count  = var.enable_what2play_client_deploy_role ? 1 : 0

  oidc_provider_arn = aws_iam_openid_connect_provider.github.arn
  role_name         = "what2play-client_github_deploy_role"
  policy_name       = "what2play-client_github_deploy_policy"
  subjects          = ["repo:seanezell/what2play-client:ref:refs/heads/main"]
  policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "BucketMetadata"
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:GetBucketVersioning"
        ]
        Resource = [var.what2play_client_bucket_arn]
      },
      {
        Sid    = "BucketObjects"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = ["${var.what2play_client_bucket_arn}/*"]
      },
      {
        Sid    = "CloudFrontInvalidation"
        Effect = "Allow"
        Action = [
          "cloudfront:CreateInvalidation",
          "cloudfront:GetInvalidation",
          "cloudfront:ListInvalidations"
        ]
        Resource = [var.what2play_client_distribution_arn]
      },
      {
        Sid      = "CallerIdentity"
        Effect   = "Allow"
        Action   = ["sts:GetCallerIdentity"]
        Resource = "*"
      }
    ]
  })
}

module "website_client_deploy_oidc" {
  source = "./modules/github_oidc_repo_role"
  count  = var.enable_website_client_deploy_role ? 1 : 0

  oidc_provider_arn = aws_iam_openid_connect_provider.github.arn
  role_name         = "website-client_github_deploy_role"
  policy_name       = "website-client_github_deploy_policy"
  subjects          = ["repo:seanezell/website-client:ref:refs/heads/main"]
  policy_json = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "BucketMetadata"
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:GetBucketVersioning"
        ]
        Resource = [var.website_client_bucket_arn]
      },
      {
        Sid    = "BucketObjects"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = ["${var.website_client_bucket_arn}/*"]
      },
      {
        Sid    = "CloudFrontInvalidation"
        Effect = "Allow"
        Action = [
          "cloudfront:CreateInvalidation",
          "cloudfront:GetInvalidation",
          "cloudfront:ListInvalidations"
        ]
        Resource = [var.website_client_distribution_arn]
      },
      {
        Sid      = "CallerIdentity"
        Effect   = "Allow"
        Action   = ["sts:GetCallerIdentity"]
        Resource = "*"
      }
    ]
  })
}
