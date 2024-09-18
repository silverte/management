################################################################################
# KMS Module
# reference: https://github.com/terraform-aws-modules/terraform-aws-kms
################################################################################
module "kms-rds" {
  source = "terraform-aws-modules/kms/aws"
  create = var.enable_kms_rds

  description         = "RDS customer managed key"
  enable_key_rotation = true
  # rotation_period_in_days = 365
  is_enabled   = true
  key_usage    = "ENCRYPT_DECRYPT"
  multi_region = false

  # Policy
  key_owners = [data.aws_caller_identity.current.arn]
  key_administrators = [
    data.aws_caller_identity.current.arn
  ]
  key_users = var.kms_rds_user_account_arn
  # Aliases
  aliases = ["rds"]

  tags = merge(
    local.tags,
    {
      "Name" = "kms-${var.service}-rds"
    }
  )
}
