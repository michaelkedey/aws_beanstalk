# dev.tfvars
#bucket_name = "myoneandonly-dev-bucket"
# bucket2_name = "appdev-versions"
#app_name = "dev-sample_app12"
max_instance = 4
min_instance = 2
root_vol_type = "gp2"
root_vol_size = 30
beanstalk_env_name = "my-dev-beanstalk2"
instance_type = "t2.micro"
app_file_path = "./s3_uploads/dotnet-linux2.zip"
app_key = "dotnet-linux2.zip"
#version_name = "version0.0.1"

#backend
# bucket = "web-pro-bucket"
# key    = "dev/terraform.tfstate"
# region = "us-east-1"


