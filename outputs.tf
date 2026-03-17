output "dynamodb_table_name" {
  description = "DynamoDB table name"
  value       = module.dynamodb.table_name
}

output "gcs_bucket_name" {
  description = "GCS bucket name"
  value       = module.gcs.bucket_name
}

output "lambda1_name" {
  description = "Lambda 1 function name"
  value       = module.lambda.lambda1_name
}

output "lambda2_name" {
  description = "Lambda 2 function name"
  value       = module.lambda.lambda2_name
}

output "sqs_queue_url" {
  description = "SQS main queue URL"
  value       = module.sqs.queue_url
}