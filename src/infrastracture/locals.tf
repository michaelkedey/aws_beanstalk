#get the aws current region
data "aws_region" "current" {}

#get the aws account id
data "aws_caller_identity" "current" {}

locals {
  beanstalk_bucket_id = "elasticbeanstalk-${data.aws_region.current.name}-${data.aws_caller_identity.current.account_id}"
}