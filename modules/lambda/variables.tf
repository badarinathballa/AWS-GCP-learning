variable "environment" {
  description = "Environment name"
  type        = string
}

variable "lambda1_role_arn" {
  description = "IAM role ARN for Lambda 1 — from IAM module"
  type        = string
}

variable "lambda2_role_arn" {
  description = "IAM role ARN for Lambda 2 — from IAM module"
  type        = string
}

variable "stream_arn" {
  description = "DynamoDB stream ARN — trigger for Lambda 1"
  type        = string
}

variable "queue_arn" {
  description = "SQS queue ARN — trigger for Lambda 2"
  type        = string
}

variable "queue_url" {
  description = "SQS queue URL — passed to Lambda 1 as env var"
  type        = string
}

variable "secret_name" {
  description = "Secrets Manager secret name — passed to Lambda 2"
  type        = string
}

variable "gcs_bucket_name" {
  description = "GCS bucket name — passed to Lambda 2"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}