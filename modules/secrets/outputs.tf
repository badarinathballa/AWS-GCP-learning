output "secret_arn" {
  description = "ARN of the secret — needed by Lambda IAM policy"
  value       = aws_secretsmanager_secret.gcp_key.arn
}

output "secret_name" {
  description = "Name of the secret — used by Lambda code"
  value       = aws_secretsmanager_secret.gcp_key.name
}