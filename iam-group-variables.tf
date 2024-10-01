# Whether to create an IAM User (True or False)
variable "create_iam_user" {
  description = "Whether to create an IAM User"
  type        = bool
  default     = false
}

# # IAM Users
# variable "iam_users" {
#   description = "IAM Users"
#   type        = list(string)
#   default     = []
# }
