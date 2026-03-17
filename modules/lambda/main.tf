# ═══════════════════════════════════════════════════════
# LAMBDA 1 — Stream Processor
# ═══════════════════════════════════════════════════════

resource "aws_lambda_function" "lambda1" {
  filename         = "${path.module}/code/lambda1_deployment.zip"
  function_name    = "dynamodb-stream-processor-${var.environment}"
  role             = var.lambda1_role_arn
  handler          = "lambda1_function.lambda_handler"
  runtime          = "python3.12"
  timeout          = 60
  memory_size      = 128

  source_code_hash = filebase64sha256(
    "${path.module}/code/lambda1_deployment.zip"
  )

  environment {
    variables = {
      SQS_QUEUE_URL   = var.queue_url
      AWS_REGION_NAME = var.aws_region
    }
  }

  tags = {
    environment = var.environment
    managed_by  = "terraform"
  }
}

# ─── Trigger: DynamoDB Stream → Lambda 1 ───────────────
resource "aws_lambda_event_source_mapping" "dynamodb_trigger" {
  event_source_arn  = var.stream_arn
  function_name     = aws_lambda_function.lambda1.arn
  starting_position = "LATEST"
  batch_size        = 10
  enabled           = true
}

# ═══════════════════════════════════════════════════════
# LAMBDA 2 — GCS Uploader
# ═══════════════════════════════════════════════════════

resource "aws_lambda_function" "lambda2" {
  filename         = "${path.module}/code/lambda2_deployment.zip"
  function_name    = "gcs-uploader-${var.environment}"
  role             = var.lambda2_role_arn
  handler          = "lambda2_function.lambda_handler"
  runtime          = "python3.12"
  timeout          = 300
  memory_size      = 256

  source_code_hash = filebase64sha256(
    "${path.module}/code/lambda2_deployment.zip"
  )

  environment {
    variables = {
      AWS_REGION_NAME = var.aws_region
      SECRET_NAME     = var.secret_name
      GCS_BUCKET_NAME = var.gcs_bucket_name
    }
  }

  tags = {
    environment = var.environment
    managed_by  = "terraform"
  }
}

# ─── Trigger: SQS → Lambda 2 ───────────────────────────
resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = var.queue_arn
  function_name    = aws_lambda_function.lambda2.arn
  batch_size       = 5
  enabled          = true
}
