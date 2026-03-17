output "bucket_name" {
  description = "Name of the GCS bucket"
  value       = google_storage_bucket.this.name
}

output "bucket_url" {
  description = "URL of the GCS bucket"
  value       = google_storage_bucket.this.url
}

output "service_account_email" {
  description = "Email of the service account"
  value       = google_service_account.this.email
}

output "service_account_key" {
  description = "Base64 encoded service account key JSON"
  value       = google_service_account_key.this.private_key
  sensitive   = true
}