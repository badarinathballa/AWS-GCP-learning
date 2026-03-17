output "lambda1_arn" {
  description = "ARN of Lambda 1"
  value       = aws_lambda_function.lambda1.arn
}

output "lambda2_arn" {
  description = "ARN of Lambda 2"
  value       = aws_lambda_function.lambda2.arn
}

output "lambda1_name" {
  description = "Name of Lambda 1"
  value       = aws_lambda_function.lambda1.function_name
}

output "lambda2_name" {
  description = "Name of Lambda 2"
  value       = aws_lambda_function.lambda2.function_name
}