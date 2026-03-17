resource "aws_dynamodb_table" "this" {
  name         = "${var.table_name}-${var.environment}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = var.hash_key

  # ─── PARTITION KEY DEFINITION ──────────────────────
  attribute {
    name = var.hash_key
    type = "S"
  }

  # ─── STREAMS ───────────────────────────────────────
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  # ─── TAGS ──────────────────────────────────────────
  tags = {
    environment = var.environment
    managed_by  = "terraform"
    purpose     = "dynamodb-to-gcs-poc"
  }
}