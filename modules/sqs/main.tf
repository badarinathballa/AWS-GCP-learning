# ─── DEAD LETTER QUEUE — created FIRST ─────────────────
# DLQ must exist before main queue because
# main queue references DLQ ARN in redrive_policy!
resource "aws_sqs_queue" "dlq" {
  name                      = "dynamodb-gcs-dlq-${var.environment}"
  message_retention_seconds = 1209600

  tags = {
    environment = var.environment
    managed_by  = "terraform"
    purpose     = "dead-letter-queue"
  }
}

# ─── MAIN QUEUE ────────────────────────────────────────
resource "aws_sqs_queue" "main" {
  name                       = "dynamodb-gcs-queue-${var.environment}"
  visibility_timeout_seconds = var.visibility_timeout_seconds
  message_retention_seconds  = var.message_retention_seconds

  # ─── LINK MAIN QUEUE TO DLQ ──────────────────────────
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = var.max_receive_count
  })

  tags = {
    environment = var.environment
    managed_by  = "terraform"
    purpose     = "main-processing-queue"
  }
}