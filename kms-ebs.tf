################################################################################
# KMS Module
# reference: https://github.com/terraform-aws-modules/terraform-aws-kms
################################################################################
module "kms-ebs" {
  source = "terraform-aws-modules/kms/aws"
  create = var.create_kms_ebs

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
  key_users = [
    "arn:aws:iam::${var.accounts["network"]}:root",
    "arn:aws:iam::${var.accounts["shared"]}:root",
    "arn:aws:iam::${var.accounts["sandbox"]}:root",
    "arn:aws:iam::${var.accounts["dev"]}:root",
    "arn:aws:iam::${var.accounts["stg"]}:root",
    "arn:aws:iam::${var.accounts["prd"]}:root"
  ]

  # Aliases
  aliases = ["ebs"]

  tags = merge(
    local.tags,
    {
      "Name" = "kms-${var.service}-ebs"
    }
  )
}
