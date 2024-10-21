# Whether to create an S3 Bucket for logs (True or False)
variable "create_s3_cloudtrail_log" {
  description = "Whether to create an S3 Bucket for logs"
  type        = bool
  default     = false
}

variable "create_s3_config_log" {
  description = "Whether to create an S3 Bucket for logs"
  type        = bool
  default     = false
}

variable "create_s3_vpc_flow_log" {
  description = "Whether to create an S3 Bucket for logs"
  type        = bool
  default     = false
}

variable "create_s3_access_log" {
  description = "Whether to create an S3 Bucket for logs"
  type        = bool
  default     = false
}
