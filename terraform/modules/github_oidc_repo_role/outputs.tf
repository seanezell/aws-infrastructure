output "role_arn" {
  value       = aws_iam_role.this.arn
  description = "IAM role ARN"
}

output "role_name" {
  value       = aws_iam_role.this.name
  description = "IAM role name"
}

output "policy_name" {
  value       = aws_iam_role_policy.this.name
  description = "Inline policy name"
}
