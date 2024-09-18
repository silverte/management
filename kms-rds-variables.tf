# Whether to create an KMS RDS (True or False)
variable "enable_kms_rds" {
  description = "Whether to create an KMS RDS"
  type        = bool
  default     = false
}

# KMS User Account ARNs
variable "kms_rds_user_account_arns" {
  description = "KMS User Account ARNs"
  type        = list(string)
  default     = []
}
