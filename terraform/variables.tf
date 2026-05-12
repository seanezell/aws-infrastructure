variable "enable_what2play_client_deploy_role" {
  description = "Create deploy role for what2play-client when true"
  type        = bool
  default     = false
}

variable "what2play_client_bucket_arn" {
  description = "S3 bucket ARN for what2play-client deploy target"
  type        = string
  default     = ""
}

variable "what2play_client_distribution_arn" {
  description = "CloudFront distribution ARN for what2play-client invalidations"
  type        = string
  default     = ""
}

variable "enable_website_client_deploy_role" {
  description = "Create deploy role for website-client when true"
  type        = bool
  default     = false
}

variable "website_client_bucket_arn" {
  description = "S3 bucket ARN for website-client deploy target"
  type        = string
  default     = ""
}

variable "website_client_distribution_arn" {
  description = "CloudFront distribution ARN for website-client invalidations"
  type        = string
  default     = ""
}
