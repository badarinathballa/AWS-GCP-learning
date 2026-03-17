output "lambda1_role_arn" {
  description = "ARN of Lambda 1 role — used by lambda module"
  value       = aws_iam_role.lambda1.arn
}

output "lambda2_role_arn" {
  description = "ARN of Lambda 2 role — used by lambda module"
  value       = aws_iam_role.lambda2.arn
}

output "lambda1_role_name" {
  description = "Name of Lambda 1 role"
  value       = aws_iam_role.lambda1.name
}

output "lambda2_role_name" {
  description = "Name of Lambda 2 role"
  value       = aws_iam_role.lambda2.name
}