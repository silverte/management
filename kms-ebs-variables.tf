# Whether to create an KMS EBS (True or False)
variable "enable_kms_ebs" {
  description = "Whether to create an KMS EBS"
  type        = bool
  default     = false
}

# KMS User Account ARN
variable "kms_ebs_user_account_arn" {
  description = "KMS User Account ARN"
  type        = list(string)
  default     = []
}