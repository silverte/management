##########################################################################
# IAM Module
# reference: https://github.com/terraform-aws-modules/terraform-aws-iam
##########################################################################
module "iam_user" {
  source      = "terraform-aws-modules/iam/aws//modules/iam-user"
  create_user = var.create_iam_user

  name = "silvrete@sk.com"

  create_iam_user_login_profile = false
  create_iam_access_key         = false
  password_reset_required       = false
  force_destroy                 = true
  tags = merge(
    local.tags,
    {
      Name = "silvrete@sk.com"
    },
  )
}

#############################################################################################
# IAM group where user is allowed to assume admin role in production AWS account
#############################################################################################
module "iam_group_administrator" {
  source = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"

  name = "group-${var.service}-${var.environment}-administrator"

  group_users = [
    module.iam_user.iam_user_name
  ]

  custom_group_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}

##################################################################################################
# IAM assumable role for admin
##################################################################################################
module "iam_assumable_role_admin" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"

  # https://aws.amazon.com/blogs/security/announcing-an-update-to-iam-role-trust-policy-behavior/
  allow_self_assume_role = true

  trusted_role_arns = [
    "arn:aws:iam::533616270150:root",
    //"arn:aws:iam::928933996765:group/group-esp-management-administrator"
  ]

  # trusted_role_services = [
  #   "codedeploy.amazonaws.com"
  # ]

  create_role             = true
  create_instance_profile = false

  role_name           = "role-${var.service}-${var.environment}-admin"
  role_requires_mfa   = true
  attach_admin_policy = true

  tags = merge(
    local.tags,
    {
      Name = "role-${var.service}-${var.environment}-admin"
    },
  )
}
