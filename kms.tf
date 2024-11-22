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

module "kms-rds" {
  source = "terraform-aws-modules/kms/aws"
  create = var.create_kms_rds

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
  key_users = [
    "arn:aws:iam::${var.accounts["network"]}:root",
    "arn:aws:iam::${var.accounts["shared"]}:root",
    "arn:aws:iam::${var.accounts["sandbox"]}:root",
    "arn:aws:iam::${var.accounts["dev"]}:root",
    "arn:aws:iam::${var.accounts["stg"]}:root",
    "arn:aws:iam::${var.accounts["prd"]}:root"
  ]

  # Aliases
  aliases = ["rds"]

  tags = merge(
    local.tags,
    {
      "Name" = "kms-${var.service}-rds"
    }
  )
}

module "kms-enc" {
  source = "terraform-aws-modules/kms/aws"
  create = var.create_kms_enc

  description         = "Data Encryption customer managed key"
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
  aliases = ["enc"]

  tags = merge(
    local.tags,
    {
      "Name" = "kms-${var.service}-enc"
    }
  )
}

module "kms-cloudtrail" {
  source = "terraform-aws-modules/kms/aws"
  create = var.create_kms_cloudtrail

  description         = "Data Encryption customer managed key"
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
  aliases = ["cloudtrail"]

  tags = merge(
    local.tags,
    {
      "Name" = "kms-${var.service}-cloudtrail"
    }
  )
}

module "kms-guardduty" {
  source = "terraform-aws-modules/kms/aws"
  create = var.create_kms_guardduty

  description         = "Data Encryption customer managed key"
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
  aliases = ["guardduty"]

  tags = merge(
    local.tags,
    {
      "Name" = "kms-${var.service}-guardduty"
    }
  )
}
