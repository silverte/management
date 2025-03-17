# kms key owners
variable "kms_key_owners" {
  description = "kms_key_owners"
  type        = list(string)
  default     = [""]
}

# kms key administrators
variable "kms_key_administrators" {
  description = "kms_key_administrators"
  type        = list(string)
  default     = [""]
}


# Whether to create an KMS EBS (True or False)
variable "create_kms_ebs" {
  description = "Whether to create an KMS EBS"
  type        = bool
  default     = false
}

# Whether to create an KMS RDS (True or False)
variable "create_kms_rds" {
  description = "Whether to create an KMS RDS"
  type        = bool
  default     = false
}

# Whether to create an KMS Data Encryption (True or False)
variable "create_kms_enc" {
  description = "Whether to create an KMS Data Encryption"
  type        = bool
  default     = false
}

# Whether to create an KMS Data Encryption (True or False)
variable "create_kms_cloudtrail" {
  description = "Whether to create an KMS Data Encryption"
  type        = bool
  default     = false
}

# Whether to create an KMS Data Encryption (True or False)
variable "create_kms_guardduty" {
  description = "Whether to create an KMS Data Encryption"
  type        = bool
  default     = false
}
