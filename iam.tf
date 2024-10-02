##########################################################################
# IAM Module
# reference: https://github.com/terraform-aws-modules/terraform-aws-iam
##########################################################################
module "iam_account" {
  source                         = "terraform-aws-modules/iam/aws//modules/iam-account"
  create_account_password_policy = var.create_account_password_policy

  account_alias = "${var.service}-${var.environment}"

  max_password_age             = 365
  minimum_password_length      = 8
  password_reuse_prevention    = 3
  require_lowercase_characters = false
  require_uppercase_characters = false
  require_symbols              = false
  require_numbers              = false
}

module "iam_user" {
  source      = "terraform-aws-modules/iam/aws//modules/iam-user"
  create_user = var.create_iam
  for_each    = toset(var.admin_iam_users)

  name                          = each.key
  create_iam_user_login_profile = false
  create_iam_access_key         = false
  password_reset_required       = false
  force_destroy                 = true
  tags = merge(
    local.tags,
    {
      Name = each.key
    },
  )
}

module "iam_group_administrator" {
  source = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  count  = var.create_iam ? 1 : 0

  name        = "group-${var.service}-${var.environment}-administrator"
  group_users = var.admin_iam_users

  enable_mfa_enforcement = false
  custom_group_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess",
    module.iam_policy_restrict_ip.arn,
    module.iam_policy_restrict_region.arn
  ]
}

module "iam_group_poweruser" {
  source = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  count  = var.create_iam ? 1 : 0

  name = "group-${var.service}-${var.environment}-powerUser"
  custom_group_policy_arns = [
    "arn:aws:iam::aws:policy/PowerUserAccess",
    module.iam_policy_restrict_ip.arn,
    module.iam_policy_restrict_region.arn
  ]
}

module "iam_group_databaseadmin" {
  source = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  count  = var.create_iam ? 1 : 0

  name = "group-${var.service}-${var.environment}-databaseAdmin"
  custom_group_policy_arns = [
    "arn:aws:iam::aws:policy/job-function/DatabaseAdministrator",
    module.iam_policy_restrict_ip.arn,
    module.iam_policy_restrict_region.arn
  ]
}

module "iam_group_systemadmin" {
  source = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  count  = var.create_iam ? 1 : 0

  name = "group-${var.service}-${var.environment}-systemAdmin"
  custom_group_policy_arns = [
    "arn:aws:iam::aws:policy/job-function/SystemAdministrator",
    module.iam_policy_restrict_ip.arn,
    module.iam_policy_restrict_region.arn
  ]
}

module "iam_group_networkadmin" {
  source = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  count  = var.create_iam ? 1 : 0

  name = "group-${var.service}-${var.environment}-networkAdmin"
  custom_group_policy_arns = [
    "arn:aws:iam::aws:policy/job-function/NetworkAdministrator",
    module.iam_policy_restrict_ip.arn,
    module.iam_policy_restrict_region.arn
  ]
}

module "iam_group_viewonly" {
  source = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  count  = var.create_iam ? 1 : 0

  name = "group-${var.service}-${var.environment}-viewOnly"
  custom_group_policy_arns = [
    "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess",
    module.iam_policy_restrict_ip.arn,
    module.iam_policy_restrict_region.arn
  ]
}

#####################################################################################
# IAM policy to restrict ip
#####################################################################################
module "iam_policy_restrict_ip" {
  source        = "terraform-aws-modules/iam/aws//modules/iam-policy"
  create_policy = var.create_iam

  name        = "policy-${var.service}-${var.environment}-restrict-ip"
  path        = "/"
  description = "IAM policy to restrict ip"

  policy = <<EOF
{
	"Statement": [
		{
			"Action": "*",
			"Condition": {
				"Bool": {
					"aws:ViaAWSService": "false"
				},
				"NotIpAddress": {
					"aws:SourceIp": [
						"211.45.61.18/32",
						"59.6.169.100/32",
						"211.234.226.89/32",
						"203.251.242.124/32"
					]
				}
			},
			"Effect": "Deny",
			"Resource": "*"
		}
	],
	"Version": "2012-10-17"
}
EOF

  tags = merge(
    local.tags,
    {
      Name = "policy-${var.service}-${var.environment}-restrict-ip"
    },
  )
}

#####################################################################################
# IAM policy to restrict region
#####################################################################################
module "iam_policy_restrict_region" {
  source        = "terraform-aws-modules/iam/aws//modules/iam-policy"
  create_policy = var.create_iam

  name        = "policy-${var.service}-${var.environment}-restrict-region"
  path        = "/"
  description = "IAM policy to restrict region"

  policy = <<EOF
{
  "Statement": [
      {
          "Action": "*",
          "Condition": {
              "StringNotEquals": {
                  "aws:RequestedRegion": [
                      "ap-northeast-2",
                      "us-east-1"
                  ]
              }
          },
          "Effect": "Deny",
          "Resource": "*"
      },
      {
          "Condition": {
              "StringEquals": {
                  "aws:RequestedRegion": "us-east-1"
              }
          },
          "Effect": "Deny",
          "NotAction": [
              "iam:*",
              "s3:*",
              "cloudfront:*",
              "route53:*",
              "route53domains:*",
              "route53resolver:*",
              "ec2:DescribeVpcs",
              "access-analyzer:*",
              "acm:*",
              "organizations:*"
          ],
          "Resource": "*"
      }
  ],
  "Version": "2012-10-17"
}
EOF

  tags = merge(
    local.tags,
    {
      Name = "policy-${var.service}-${var.environment}-restrict-region"
    },
  )
}

# module "iam_policy_from_data_source" {
#   source = "../../modules/iam-policy"

#   name        = "example_from_data_source"
#   path        = "/"
#   description = "My example policy"

#   policy = data.aws_iam_policy_document.bucket_policy.json

#   tags = {
#     PolicyDescription = "Policy created using example from data source"
#   }
# }
