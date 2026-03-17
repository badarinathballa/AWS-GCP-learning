variable "table_name" {
  description = "Name of the DynamoDB table"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "hash_key" {
  description = "Partition key name for the table"
  type        = string
  default     = "employee_id"
}