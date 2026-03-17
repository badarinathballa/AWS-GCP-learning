output "queue_arn" {
  description = "ARN of main queue — used by IAM + Lambda modules"
  value       = aws_sqs_queue.main.arn
}

output "queue_url" {
  description = "URL of main queue — used by Lambda 1 to send messages"
  value       = aws_sqs_queue.main.url
}

output "dlq_arn" {
  description = "ARN of DLQ — used by IAM module"
  value       = aws_sqs_queue.dlq.arn
}

output "queue_name" {
  description = "Name of main queue"
  value       = aws_sqs_queue.main.name
}