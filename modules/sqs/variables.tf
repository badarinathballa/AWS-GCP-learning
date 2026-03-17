variable "environment" {
  description = "Environment name"
  type        = string
}

variable "visibility_timeout_seconds" {
  description = "How long message is hidden after Lambda reads it"
  type        = number
  default     = 300
}

variable "message_retention_seconds" {
  description = "How long message stays in queue if not processed"
  type        = number
  default     = 1209600
}

variable "max_receive_count" {
  description = "How many times to retry before sending to DLQ"
  type        = number
  default     = 3
}