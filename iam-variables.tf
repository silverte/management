# Whether to create an IAM (True or False)
variable "create_iam" {
  description = "Whether to create an IAM"
  type        = bool
  default     = false
}

# Whether to create account password policy (True or False)
variable "create_account_password_policy" {
  description = "Whether to create account password policy"
  type        = bool
  default     = false
}

# IAM Users
variable "iam_user_admins" {
  description = "IAM Users"
  type        = list(string)
  default     = []
}
