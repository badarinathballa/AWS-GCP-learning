output "table_name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.this.name
}

output "table_arn" {
  description = "ARN of DynamoDB table — used by IAM module"
  value       = aws_dynamodb_table.this.arn
}

output "stream_arn" {
  description = "ARN of DynamoDB stream — used as Lambda 1 trigger"
  value       = aws_dynamodb_table.this.stream_arn
}