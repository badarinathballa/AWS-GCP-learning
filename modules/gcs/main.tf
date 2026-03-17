# ─── GCS BUCKET ────────────────────────────────────────
resource "google_storage_bucket" "this" {
  name          = var.bucket_name
  location      = var.region
  force_destroy = true

  uniform_bucket_level_access = true

  labels = {
    environment = var.environment
    managed_by  = "terraform"
  }
}

# ─── SERVICE ACCOUNT ───────────────────────────────────
resource "google_service_account" "this" {
  account_id   = "aws-gcp-${var.environment}"
  display_name = "AWS to GCP Service Account - ${var.environment}"
  description  = "Service account for AWS Lambda to write to GCS"
}

# ─── SERVICE ACCOUNT KEY ───────────────────────────────
resource "google_service_account_key" "this" {
  service_account_id = google_service_account.this.name
}

# ─── BIND SERVICE ACCOUNT TO BUCKET ────────────────────
resource "google_storage_bucket_iam_member" "this" {
  bucket = google_storage_bucket.this.name
  role   = "roles/storage.objectCreator"
  member = "serviceAccount:${google_service_account.this.email}"
}