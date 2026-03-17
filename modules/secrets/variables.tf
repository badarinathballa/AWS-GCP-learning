variable "environment" {
  description = "Environment name"
  type        = string
}

variable "gcp_service_account_key" {
  description = "GCP service account key JSON — base64 encoded"
  type        = string
  sensitive   = true
}