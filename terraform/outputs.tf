output "aws_infrastructure_github_actions_role_arn" {
  value       = module.aws_infrastructure_oidc.role_arn
  description = "IAM role ARN for aws-infrastructure GitHub workflow"
}

output "what2play_infrastructure_github_actions_role_arn" {
  value       = module.what2play_infrastructure_oidc.role_arn
  description = "IAM role ARN for what2play-infrastructure GitHub workflow"
}

output "what2play_services_github_actions_role_arn" {
  value       = module.what2play_services_oidc.role_arn
  description = "IAM role ARN for what2play-services GitHub workflow"
}

output "website_infrastructure_github_actions_role_arn" {
  value       = module.website_infrastructure_oidc.role_arn
  description = "IAM role ARN for website-infrastructure GitHub workflow"
}

output "what2play_client_deploy_role_arn" {
  value       = var.enable_what2play_client_deploy_role ? module.what2play_client_deploy_oidc[0].role_arn : null
  description = "IAM role ARN for what2play-client deploy workflow"
}

output "website_client_deploy_role_arn" {
  value       = var.enable_website_client_deploy_role ? module.website_client_deploy_oidc[0].role_arn : null
  description = "IAM role ARN for website-client deploy workflow"
}
