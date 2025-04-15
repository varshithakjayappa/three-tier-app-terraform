region = "eu-central-1"
env = "dev"
project_name = "cea-project"
profile = "terrraform-user"
bucket_name ="cea-project-dynamic-app"

#route53 details
domain_nmae = "thedevlearn.site"

#vpc
vpc_cidr                     = "10.0.0.0/16"
public_subnet_az1_cidr       = "10.0.0.0/24"
public_subnet_az2_cidr       = "10.1.0.0/24"
private_app_subnet_az1_cidr  = "10.2.0.0/24"
private_app_subnet_az2_cidr  = "10.3.0.0/24"
private_data_subnet_az1_cidr = "10.4.0.0/24"
private_data_subnet_az2_cidr = "10.5.0.0/24"

#RDS 
database_identifier     = "dev-rds-db"
database_engine         = "mysql"
engine_version          = "8.0.36"
database_instance_class = "db.t3.medium"
db_master_username      = "admin123"
db_master_password      = "admin123"
database_name           = "applicationdb"
parameter_groupname     = "dev-para-group"