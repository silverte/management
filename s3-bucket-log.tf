################################################################################
# S3 Module
# reference: https://github.com/terraform-aws-modules/terraform-aws-s3-bucket
#            https://github.com/terraform-aws-modules/terraform-aws-s3-object
################################################################################
################################################################################
# AWS Config log
################################################################################
module "s3_bucket_cloudtrail_log" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  create_bucket = var.create_s3_cloudtrail_log

  bucket        = "s3-${var.service}-${var.environment}-cloudtrail-log"
  force_destroy = true

  tags = merge(
    local.tags,
    {
      "Name" = "s3-${var.service}-${var.environment}-cloudtrail-log"
    }
  )
}

resource "aws_s3_bucket_policy" "cloudtrail_log" {
  count = var.create_s3_cloudtrail_log ? 1: 0
  bucket = module.s3_bucket_cloudtrail_log.s3_bucket_id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCrossAccountAccess"
        Effect    = "Allow"
        Principal = {
          AWS = [ 
            "arn:aws:iam::${var.accounts["network"]}:root",
            "arn:aws:iam::${var.accounts["shared"]}:root",
            "arn:aws:iam::${var.accounts["sandbox"]}:root",
            "arn:aws:iam::${var.accounts["dev"]}:root",
            "arn:aws:iam::${var.accounts["stg"]}:root",
            "arn:aws:iam::${var.accounts["prd"]}:root"
           ]
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          module.s3_bucket_cloudtrail_log.s3_bucket_arn,
          "${module.s3_bucket_cloudtrail_log.s3_bucket_arn}/*"
        ]
      }
    ]
  })
}

################################################################################
# AWS Config log
################################################################################
module "s3_bucket_config_log" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  create_bucket = var.create_s3_config_log

  bucket        = "s3-${var.service}-${var.environment}-config-log"
  force_destroy = true

  tags = merge(
    local.tags,
    {
      "Name" = "s3-${var.service}-${var.environment}-config-log"
    }
  )
}

resource "aws_s3_bucket_policy" "config_log" {
  count = var.create_s3_config_log ? 1: 0
  bucket = module.s3_bucket_config_log.s3_bucket_id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCrossAccountAccess"
        Effect    = "Allow"
        Principal = {
          AWS = [ 
            "arn:aws:iam::${var.accounts["network"]}:root",
            "arn:aws:iam::${var.accounts["shared"]}:root",
            "arn:aws:iam::${var.accounts["sandbox"]}:root",
            "arn:aws:iam::${var.accounts["dev"]}:root",
            "arn:aws:iam::${var.accounts["stg"]}:root",
            "arn:aws:iam::${var.accounts["prd"]}:root"
           ]
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          module.s3_bucket_config_log.s3_bucket_arn,
          "${module.s3_bucket_config_log.s3_bucket_arn}/*"
        ]
      }
    ]
  })
}

################################################################################
# AWS VPC flow log
################################################################################
module "s3_bucket_vpc_flow_log" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  create_bucket = var.create_s3_vpc_flow_log

  bucket        = "s3-${var.service}-${var.environment}-vpc-flow-log"
  force_destroy = true

  tags = merge(
    local.tags,
    {
      "Name" = "s3-${var.service}-${var.environment}-vpc-flow-log"
    }
  )
}

resource "aws_s3_bucket_policy" "vpc_flow_log" {
  count = var.create_s3_vpc_flow_log ? 1: 0
  bucket = module.s3_bucket_vpc_flow_log.s3_bucket_id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCrossAccountAccess"
        Effect    = "Allow"
        Principal = {
          AWS = [ 
            "arn:aws:iam::${var.accounts["network"]}:root",
            "arn:aws:iam::${var.accounts["shared"]}:root",
            "arn:aws:iam::${var.accounts["sandbox"]}:root",
            "arn:aws:iam::${var.accounts["dev"]}:root",
            "arn:aws:iam::${var.accounts["stg"]}:root",
            "arn:aws:iam::${var.accounts["prd"]}:root"
           ]
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          module.s3_bucket_vpc_flow_log.s3_bucket_arn,
          "${module.s3_bucket_vpc_flow_log.s3_bucket_arn}/*"
        ]
      }
    ]
  })
}

################################################################################
# AWS S3 access log
################################################################################
module "s3_bucket_access_log" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  create_bucket = var.create_s3_access_log

  bucket        = "s3-${var.service}-${var.environment}-s3-access-log"
  force_destroy = true

  tags = merge(
    local.tags,
    {
      "Name" = "s3-${var.service}-${var.environment}-s3-access-log"
    }
  )
}

resource "aws_s3_bucket_policy" "s3_access_log" {
  count = var.create_s3_access_log ? 1: 0
  bucket = module.s3_bucket_access_log.s3_bucket_id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCrossAccountAccess"
        Effect    = "Allow"
        Principal = {
          AWS = [ 
            "arn:aws:iam::${var.accounts["network"]}:root",
            "arn:aws:iam::${var.accounts["shared"]}:root",
            "arn:aws:iam::${var.accounts["sandbox"]}:root",
            "arn:aws:iam::${var.accounts["dev"]}:root",
            "arn:aws:iam::${var.accounts["stg"]}:root",
            "arn:aws:iam::${var.accounts["prd"]}:root"
           ]
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          module.s3_bucket_access_log.s3_bucket_arn,
          "${module.s3_bucket_access_log.s3_bucket_arn}/*"
        ]
      }
    ]
  })
}