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
        "iam:ChangePassword",
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
