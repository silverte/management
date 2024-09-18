# Whether to create an KMS RDS (True or False)
variable "enable_kms_rds" {
  description = "Whether to create an KMS RDS"
  type        = bool
  default     = false
}

# KMS User Account ARN
variable "kms_rds_user_account_arn" {
  description = "KMS User Account ARN"
  type        = list(string)
  default     = []
}
