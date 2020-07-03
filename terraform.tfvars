region              = "ap-southeast-2"
project_name        = "AWSECSDemo"
database_name       = "app"
database_username   = "demouser"

# only for demo purpose
# can be generated randomly in secrets_manager and rotate regularly
database_password   = "demo1101ecsawsxatradmo" 

nginx_version_tag   = 1

# change this version if any changes in app source code
# this will trigger new image build in ecr and new version of task definition
app_version_tag     = 1

app_git_url         = "https://github.com/servian/TechTestApp.git"

# set to false to speed up demo provision
multi_az = false 
backup_retention_period = 0

# set this to low value to trigger service auto scaling and capacity provider
target_value = 1