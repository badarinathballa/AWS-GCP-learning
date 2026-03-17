# ─── AWS ───────────────────────────────────────────────
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-2"
}

variable "environment" {
  description = "Environment name — dev, staging, prod"
  type        = string
  default     = "dev"
}

# ─── GCP ───────────────────────────────────────────────
variable "gcp_project_id" {
  description = "GCP project ID"
  type        = string
}

variable "gcp_region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "gcs_bucket_name" {
  description = "Name of GCS bucket to store DynamoDB exports"
  type        = string
}

# ─── DynamoDB ──────────────────────────────────────────
variable "dynamodb_table_name" {
  description = "Name of DynamoDB table"
  type        = string
  default     = "employees"
}

