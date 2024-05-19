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
  version_label    = module.app_version.beanstalk_app_version_label

}

#4 upload .net zipped-app to beanstalk bucket
module "upload_dot_net" {
  source       = "./modules/file_upload"
  file_path    = var.app_file_upload #"./s3_uploads/Jokes.zip" 
  s3_bucket_id = local.beanstalk_bucket_id
  key          = var.app_key
}

#5 create app version from zip
module "app_version" {
  source           = "./modules/app_version"
  application      = module.dotnet_app.app_name
  app_key          = var.app_key
  bucket_id        = local.beanstalk_bucket_id
  app_version_name = "${var.app_version}-${timestamp()}"
}
