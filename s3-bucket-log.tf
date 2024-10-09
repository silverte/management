################################################################################
# S3 Module
# reference: https://github.com/terraform-aws-modules/terraform-aws-s3-bucket
#            https://github.com/terraform-aws-modules/terraform-aws-s3-object
################################################################################
module "s3_bucket_log" {
  source        = "terraform-aws-modules/s3-bucket/aws"
  create_bucket = var.create_s3_bucket_log
  for_each      = toset(var.s3_bucket_log_names)

  bucket        = "s3-${var.service}-${var.environment}-${each.key}"
  force_destroy = true

  tags = merge(
    local.tags,
    {
      "Name" = "s3-${var.service}-${var.environment}-${each.key}"
    }
  )
}
