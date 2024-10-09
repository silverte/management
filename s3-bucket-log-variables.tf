# Whether to create an S3 Bucket for logs (True or False)
variable "create_s3_bucket_log" {
  description = "Whether to create an S3 Bucket for logs"
  type        = bool
  default     = false
}

# S3 Bucket Names
variable "s3_bucket_log_names" {
  description = "S3 Bucket Names"
  type        = list(string)
  default     = []
}
