# Whether to create an KMS EBS (True or False)
variable "enable_kms_ebs" {
  description = "Whether to create an KMS EBS"
  type        = bool
  default     = false
}

# KMS User Account ARNs
variable "kms_ebs_use_account_arns" {
  description = "KMS Use Account ARNs"
  type        = list(string)
  default     = []
}
