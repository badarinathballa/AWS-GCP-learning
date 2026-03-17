# ─── SECRET CONTAINER ──────────────────────────────────
resource "aws_secretsmanager_secret" "gcp_key" {
  name                    = "gcp-service-account-key-${var.environment}"
  description             = "GCP service account key for Lambda to write to GCS"
  recovery_window_in_days = 0

  tags = {
    environment = var.environment
    managed_by  = "terraform"
  }
}

# ─── SECRET VALUE ──────────────────────────────────────
resource "aws_secretsmanager_secret_version" "gcp_key" {
  secret_id     = aws_secretsmanager_secret.gcp_key.id
  secret_string = base64decode(var.gcp_service_account_key)
}
