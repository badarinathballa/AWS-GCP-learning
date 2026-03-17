# ═══════════════════════════════════════════════════════
# SHARED TRUST POLICY — both lambdas use same trust
# ═══════════════════════════════════════════════════════
data "aws_iam_policy_document" "lambda_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# ═══════════════════════════════════════════════════════
# LAMBDA 1 — Stream Processor Role
# ═══════════════════════════════════════════════════════

# ─── Role ──────────────────────────────────────────────
resource "aws_iam_role" "lambda1" {
  name               = "lambda1-stream-processor-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.lambda_trust.json
  tags = {
    environment = var.environment
    managed_by  = "terraform"
  }
}

# ─── Managed Policy 1: DynamoDB Streams ────────────────
resource "aws_iam_role_policy_attachment" "lambda1_dynamodb" {
  role       = aws_iam_role.lambda1.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaDynamoDBExecutionRole"
}

# ─── Managed Policy 2: CloudWatch Logs ─────────────────
resource "aws_iam_role_policy_attachment" "lambda1_logs" {
  role       = aws_iam_role.lambda1.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# ─── Inline Policy: SQS Send ───────────────────────────
resource "aws_iam_role_policy" "lambda1_sqs_send" {
  name = "sqs-send-policy-${var.environment}"
  role = aws_iam_role.lambda1.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["sqs:SendMessage"]
        Resource = var.queue_arn
      }
    ]
  })
}

# ═══════════════════════════════════════════════════════
# LAMBDA 2 — GCS Uploader Role
# ═══════════════════════════════════════════════════════

# ─── Role ──────────────────────────────────────────────
resource "aws_iam_role" "lambda2" {
  name               = "lambda2-gcs-uploader-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.lambda_trust.json
  tags = {
    environment = var.environment
    managed_by  = "terraform"
  }
}

# ─── Managed Policy 1: SQS Read ────────────────────────
resource "aws_iam_role_policy_attachment" "lambda2_sqs" {
  role       = aws_iam_role.lambda2.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
}

# ─── Managed Policy 2: CloudWatch Logs ─────────────────
resource "aws_iam_role_policy_attachment" "lambda2_logs" {
  role       = aws_iam_role.lambda2.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# ─── Inline Policy: Secrets Manager ────────────────────
resource "aws_iam_role_policy" "lambda2_secrets" {
  name = "secrets-read-policy-${var.environment}"
  role = aws_iam_role.lambda2.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["secretsmanager:GetSecretValue"]
        Resource = var.secret_arn
      }
    ]
  })
}