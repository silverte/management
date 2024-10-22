##########################################################################
# IAM Module
# reference: https://github.com/terraform-aws-modules/terraform-aws-iam
##########################################################################
module "iam_account" {
  source                         = "terraform-aws-modules/iam/aws//modules/iam-account"
  create_account_password_policy = var.create_account_password_policy

  account_alias = var.account_alias

  max_password_age             = 90
  minimum_password_length      = 8
  password_reuse_prevention    = 3
  require_lowercase_characters = true
  require_uppercase_characters = true
  require_symbols              = true
  require_numbers              = true
}

module "iam_user" {
  source      = "terraform-aws-modules/iam/aws//modules/iam-user"
  create_user = var.create_iam
  for_each    = toset(var.iam_user_admins)

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
  group_users = var.iam_user_admins

  iam_self_management_policy_name_prefix = "policy-${var.service}-${var.environment}-iam-self-mgmt-"

  enable_mfa_enforcement = false
  custom_group_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess",
    module.iam_policy_restrict_ip.arn,
    module.iam_policy_restrict_region.arn,
    module.iam_policy_assumable_roles_admin.arn,
    module.iam_policy_force_mfa.arn
  ]
}

module "iam_group_poweruser" {
  source = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  count  = var.create_iam ? 1 : 0

  iam_self_management_policy_name_prefix = "policy-${var.service}-${var.environment}-iam-self-mgmt-"

  name = "group-${var.service}-${var.environment}-powerUser"
  custom_group_policy_arns = [
    "arn:aws:iam::aws:policy/PowerUserAccess",
    module.iam_policy_restrict_ip.arn,
    module.iam_policy_restrict_region.arn,
    module.iam_policy_assumable_roles_poweruser.arn,
    module.iam_policy_force_mfa.arn
  ]
}

module "iam_group_databaseadmin" {
  source = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  count  = var.create_iam ? 1 : 0

  iam_self_management_policy_name_prefix = "policy-${var.service}-${var.environment}-iam-self-mgmt-"

  name = "group-${var.service}-${var.environment}-databaseAdmin"
  custom_group_policy_arns = [
    "arn:aws:iam::aws:policy/job-function/DatabaseAdministrator",
    module.iam_policy_restrict_ip.arn,
    module.iam_policy_restrict_region.arn,
    module.iam_policy_assumable_roles_databaseadmin.arn,
    module.iam_policy_force_mfa.arn
  ]
}

module "iam_group_systemadmin" {
  source = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  count  = var.create_iam ? 1 : 0

  iam_self_management_policy_name_prefix = "policy-${var.service}-${var.environment}-iam-self-mgmt-"

  name = "group-${var.service}-${var.environment}-systemAdmin"
  custom_group_policy_arns = [
    "arn:aws:iam::aws:policy/job-function/SystemAdministrator",
    module.iam_policy_restrict_ip.arn,
    module.iam_policy_restrict_region.arn,
    module.iam_policy_assumable_roles_systemadmin.arn,
    module.iam_policy_force_mfa.arn
  ]
}

module "iam_group_networkadmin" {
  source = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  count  = var.create_iam ? 1 : 0

  iam_self_management_policy_name_prefix = "policy-${var.service}-${var.environment}-iam-self-mgmt-"

  name = "group-${var.service}-${var.environment}-networkAdmin"
  custom_group_policy_arns = [
    "arn:aws:iam::aws:policy/job-function/NetworkAdministrator",
    module.iam_policy_restrict_ip.arn,
    module.iam_policy_restrict_region.arn,
    module.iam_policy_assumable_roles_networkadmin.arn,
    module.iam_policy_force_mfa.arn
  ]
}

module "iam_group_viewonly" {
  source = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  count  = var.create_iam ? 1 : 0

  iam_self_management_policy_name_prefix = "policy-${var.service}-${var.environment}-iam-self-mgmt-"

  name = "group-${var.service}-${var.environment}-viewOnly"
  custom_group_policy_arns = [
    "arn:aws:iam::aws:policy/job-function/ViewOnlyAccess",
    module.iam_policy_restrict_ip.arn,
    module.iam_policy_restrict_region.arn,
    module.iam_policy_assumable_roles_viewonly.arn,
    module.iam_policy_force_mfa.arn
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

#####################################################################################
# IAM policy to force MFA
#####################################################################################
module "iam_policy_force_mfa" {
  source        = "terraform-aws-modules/iam/aws//modules/iam-policy"
  create_policy = var.create_iam

  name        = "policy-${var.service}-${var.environment}-force-mfa"
  path        = "/"
  description = "IAM policy to force MFA"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyAllExceptListedIfNoMFA",
      "Effect": "Deny",
      "NotAction": [
        "iam:CreateVirtualMFADevice",
        "iam:EnableMFADevice",
        "iam:GetUser",
        "iam:ListMFADevices",
        "iam:ListVirtualMFADevices",
        "iam:DeleteVirtualMFADevice",
        "iam:ResyncMFADevice",
        "sts:GetSessionToken"
      ],
      "Resource": "*",
      "Condition": {
        "BoolIfExists": {
          "aws:MultiFactorAuthPresent": "false"
        }
      }
    }
  ]
}
EOF

  tags = merge(
    local.tags,
    {
      Name = "policy-${var.service}-${var.environment}-force-mfa"
    },
  )
}

#####################################################################################
# IAM policy to assumable roles admin
#####################################################################################
module "iam_policy_assumable_roles_admin" {
  source        = "terraform-aws-modules/iam/aws//modules/iam-policy"
  create_policy = var.create_iam

  name        = "policy-${var.service}-${var.environment}-assumable-roles-admin"
  path        = "/"
  description = "IAM policy to assumable roles admin"

  policy = <<EOF

{
	"Statement": [
		{
			"Action": "sts:AssumeRole",
			"Effect": "Allow",
			"Resource": [
			    "arn:aws:iam::${var.accounts["network"]}:role/role-${var.service}-network-admin",
			    "arn:aws:iam::${var.accounts["shared"]}:role/role-${var.service}-shared-admin",
          "arn:aws:iam::${var.accounts["sandbox"]}:role/role-${var.service}-sandbox-admin",
          "arn:aws:iam::${var.accounts["dev"]}:role/role-${var.service}-dev-admin",
          "arn:aws:iam::${var.accounts["stg"]}:role/role-${var.service}-stg-admin",
          "arn:aws:iam::${var.accounts["prd"]}:role/role-${var.service}-prd-admin"
			]
		}
	],
	"Version": "2012-10-17"
}
EOF

  tags = merge(
    local.tags,
    {
      Name = "policy-${var.service}-${var.environment}-assumable-roles-admin"
    },
  )
}

#####################################################################################
# IAM policy to assumable roles powerUser
#####################################################################################
module "iam_policy_assumable_roles_poweruser" {
  source        = "terraform-aws-modules/iam/aws//modules/iam-policy"
  create_policy = var.create_iam

  name        = "policy-${var.service}-${var.environment}-assumable-roles-powerUser"
  path        = "/"
  description = "IAM policy to assumable roles powerUser"

  policy = <<EOF

{
	"Statement": [
		{
			"Action": "sts:AssumeRole",
			"Effect": "Allow",
			"Resource": [
			    "arn:aws:iam::${var.accounts["network"]}:role/role-${var.service}-network-powerUser",
			    "arn:aws:iam::${var.accounts["shared"]}:role/role-${var.service}-shared-powerUser",
          "arn:aws:iam::${var.accounts["sandbox"]}:role/role-${var.service}-sandbox-powerUser",
          "arn:aws:iam::${var.accounts["dev"]}:role/role-${var.service}-dev-powerUser",
          "arn:aws:iam::${var.accounts["stg"]}:role/role-${var.service}-stg-powerUser",
          "arn:aws:iam::${var.accounts["prd"]}:role/role-${var.service}-prd-powerUser"
			]
		}
	],
	"Version": "2012-10-17"
}
EOF

  tags = merge(
    local.tags,
    {
      Name = "policy-${var.service}-${var.environment}-assumable-roles-powerUser"
    },
  )
}

#####################################################################################
# IAM policy to assumable roles databaseAdmin
#####################################################################################
module "iam_policy_assumable_roles_databaseadmin" {
  source        = "terraform-aws-modules/iam/aws//modules/iam-policy"
  create_policy = var.create_iam

  name        = "policy-${var.service}-${var.environment}-assumable-roles-databaseAdmin"
  path        = "/"
  description = "IAM policy to assumable roles databaseAdmin"

  policy = <<EOF

{
	"Statement": [
		{
			"Action": "sts:AssumeRole",
			"Effect": "Allow",
			"Resource": [
			    "arn:aws:iam::${var.accounts["network"]}:role/role-${var.service}-network-databaseAdmin",
			    "arn:aws:iam::${var.accounts["shared"]}:role/role-${var.service}-shared-databaseAdmin",
          "arn:aws:iam::${var.accounts["sandbox"]}:role/role-${var.service}-sandbox-databaseAdmin",
          "arn:aws:iam::${var.accounts["dev"]}:role/role-${var.service}-dev-databaseAdmin",
          "arn:aws:iam::${var.accounts["stg"]}:role/role-${var.service}-stg-databaseAdmin",
          "arn:aws:iam::${var.accounts["prd"]}:role/role-${var.service}-prd-databaseAdmin"
			]
		}
	],
	"Version": "2012-10-17"
}
EOF

  tags = merge(
    local.tags,
    {
      Name = "policy-${var.service}-${var.environment}-assumable-roles-databaseAdmin"
    },
  )
}

#####################################################################################
# IAM policy to assumable roles systemAdmin
#####################################################################################
module "iam_policy_assumable_roles_systemadmin" {
  source        = "terraform-aws-modules/iam/aws//modules/iam-policy"
  create_policy = var.create_iam

  name        = "policy-${var.service}-${var.environment}-assumable-roles-systemAdmin"
  path        = "/"
  description = "IAM policy to assumable roles systemAdmin"

  policy = <<EOF

{
	"Statement": [
		{
			"Action": "sts:AssumeRole",
			"Effect": "Allow",
			"Resource": [
			    "arn:aws:iam::${var.accounts["network"]}:role/role-${var.service}-network-systemAdmin",
			    "arn:aws:iam::${var.accounts["shared"]}:role/role-${var.service}-shared-systemAdmin",
          "arn:aws:iam::${var.accounts["sandbox"]}:role/role-${var.service}-sandbox-systemAdmin",
          "arn:aws:iam::${var.accounts["dev"]}:role/role-${var.service}-dev-systemAdmin",
          "arn:aws:iam::${var.accounts["stg"]}:role/role-${var.service}-stg-systemAdmin",
          "arn:aws:iam::${var.accounts["prd"]}:role/role-${var.service}-prd-systemAdmin"
			]
		}
	],
	"Version": "2012-10-17"
}
EOF

  tags = merge(
    local.tags,
    {
      Name = "policy-${var.service}-${var.environment}-assumable-roles-systemAdmin"
    },
  )
}

#####################################################################################
# IAM policy to assumable roles networkAdmin
#####################################################################################
module "iam_policy_assumable_roles_networkadmin" {
  source        = "terraform-aws-modules/iam/aws//modules/iam-policy"
  create_policy = var.create_iam

  name        = "policy-${var.service}-${var.environment}-assumable-roles-networkAdmin"
  path        = "/"
  description = "IAM policy to assumable roles networkAdmin"

  policy = <<EOF

{
	"Statement": [
		{
			"Action": "sts:AssumeRole",
			"Effect": "Allow",
			"Resource": [
			    "arn:aws:iam::${var.accounts["network"]}:role/role-${var.service}-network-networkAdmin",
			    "arn:aws:iam::${var.accounts["shared"]}:role/role-${var.service}-shared-networkAdmin",
          "arn:aws:iam::${var.accounts["sandbox"]}:role/role-${var.service}-sandbox-networkAdmin",
          "arn:aws:iam::${var.accounts["dev"]}:role/role-${var.service}-dev-networkAdmin",
          "arn:aws:iam::${var.accounts["stg"]}:role/role-${var.service}-stg-networkAdmin",
          "arn:aws:iam::${var.accounts["prd"]}:role/role-${var.service}-prd-networkAdmin"
			]
		}
	],
	"Version": "2012-10-17"
}
EOF

  tags = merge(
    local.tags,
    {
      Name = "policy-${var.service}-${var.environment}-assumable-roles-networkAdmin"
    },
  )
}

#####################################################################################
# IAM policy to assumable roles viewOnly
#####################################################################################
module "iam_policy_assumable_roles_viewonly" {
  source        = "terraform-aws-modules/iam/aws//modules/iam-policy"
  create_policy = var.create_iam

  name        = "policy-${var.service}-${var.environment}-assumable-roles-viewOnly"
  path        = "/"
  description = "IAM policy to assumable roles viewOnly"

  policy = <<EOF

{
	"Statement": [
		{
			"Action": "sts:AssumeRole",
			"Effect": "Allow",
			"Resource": [
			    "arn:aws:iam::${var.accounts["network"]}:role/role-${var.service}-network-viewOnly",
			    "arn:aws:iam::${var.accounts["shared"]}:role/role-${var.service}-shared-viewOnly",
          "arn:aws:iam::${var.accounts["sandbox"]}:role/role-${var.service}-sandbox-viewOnly",
          "arn:aws:iam::${var.accounts["dev"]}:role/role-${var.service}-dev-viewOnly",
          "arn:aws:iam::${var.accounts["stg"]}:role/role-${var.service}-stg-viewOnly",
          "arn:aws:iam::${var.accounts["prd"]}:role/role-${var.service}-prd-viewOnly"
			]
		}
	],
	"Version": "2012-10-17"
}
EOF

  tags = merge(
    local.tags,
    {
      Name = "policy-${var.service}-${var.environment}-assumable-roles-viewOnly"
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
