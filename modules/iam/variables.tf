variable "environment" {
  description = "Environment name"
  type        = string
}

variable "queue_arn" {
  description = "ARN of SQS main queue — from SQS module"
  type        = string
}

variable "secret_arn" {
  description = "ARN of Secrets Manager secret — from secrets module"
  type        = string
}

