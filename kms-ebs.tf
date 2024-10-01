################################################################################
# KMS Module
# reference: https://github.com/terraform-aws-modules/terraform-aws-kms
################################################################################
module "kms-ebs" {
  source = "terraform-aws-modules/kms/aws"
  create = var.enable_kms_ebs

  description         = "EBS customer managed key"
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
  key_users = var.kms_ebs_user_account_arns

  # Aliases
  aliases = ["ebs"]

  tags = merge(
    local.tags,
    {
      "Name" = "kms-${var.service}-ebs"
    }
  )
}
