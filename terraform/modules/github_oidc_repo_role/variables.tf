variable "oidc_provider_arn" {
  description = "ARN for token.actions.githubusercontent.com OIDC provider"
  type        = string
}

variable "role_name" {
  description = "IAM role name"
  type        = string
}

variable "policy_name" {
  description = "Inline IAM role policy name"
  type        = string
}

variable "subjects" {
  description = "Allowed GitHub OIDC subject strings"
  type        = list(string)
}

variable "policy_json" {
  description = "IAM policy JSON document for inline policy"
  type        = string
}
