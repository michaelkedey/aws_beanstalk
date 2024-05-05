#get the aws current region
data "aws_region" "current" {}

#get the aws account id
data "aws_caller_identity" "current" {}

#1 create vpc 
module "vpc" {
  source = "./modules/vpc"

}

#2 create dotnet beanstalk app
module "dotnet_app" {
  source   = "./modules/app"
  app_name = var.app_name

}

#3 create beanstalk env with app above
module "beanstalk" {
  source           = "./modules/beanstalk/prod"
  instance_type    = var.instance_type
  max_instances    = var.max_instance
  min_instances    = var.min_instance
  root_volume_size = var.root_vol_size
  root_volume_type = var.root_vol_type
  vpc_id           = module.vpc.vpc_id
  subnet_ids       = module.vpc.beanstalk_subnet_lists
  #s3_logs_bucket_id   = "elasticbeanstalk-${data.aws_region.current.name}-${data.aws_caller_identity.current.account_id}"
  #s3_logs_bucket_name = "elasticbeanstalk-${data.aws_region.current.name}-${data.aws_caller_identity.current.account_id}"
  elb_subnet_ids   = module.vpc.beanstalk_lb_subnet_lists
  beanstalk_name   = var.beanstalk_env_name
  application_name = module.dotnet_app.app_name

}

# permissions for beanstalk s3 bucket
# resource "aws_s3_bucket_policy" "beanstalk_bucket_policy" {
#   bucket = "beanstalk_bucket_name"

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect   = "Allow",
#         Principal = "*",
#         Action   = ["s3:GetObject", "s3:PutObject"],
#         Resource = "arn:aws:s3:::elasticbeanstalk-${data.aws_region.current.name}-${data.aws_caller_identity.current.account_id}/*"
#       },
#     ],
#   })
# }

#5 upload .net function to beanstalk bucket
module "upload_dot_net" {
  source       = "./modules/file_upload"
  file_path    = var.app_file_upload
  s3_bucket_id = "elasticbeanstalk-${data.aws_region.current.name}-${data.aws_caller_identity.current.account_id}"
  key          = var.app_key
}

#8 create app version from zip
module "app_version" {
  source           = "./modules/app_version"
  application      = module.dotnet_app.app_name
  app_key          = var.app_key
  bucket_id        = "elasticbeanstalk-${data.aws_region.current.name}-${data.aws_caller_identity.current.account_id}"
  app_version_name = "v2"
}

