variable "aws_region" {
  type = string
  description = "aws region"
}

variable "env" {
  type = string
  description = "dev"
}

variable "domain_name" {
  
}

variable "vpc_cidr" {

}

variable "project_name" {}

variable "profile" {
  
}

#s3bucket
variable "bucket_name" {}

#vpc variables
variable "vpc_cidr" {}
variable "public_subnet_az1_cidr" {}
variable "public_subnet_az2_cidr" {}
variable "private_app_subnet_az1_cidr" {}
variable "private_app_subnet_az2_cidr" {}
variable "private_data_subnet_az1_cidr" {}
variable "private_data_subnet_az2_cidr" {}
variable "availability_zone_1a" {}
variable "availability_zone_1b" {}
variable "vpc_id" {}

#rds variables
variable "project_name" {}
variable "database_name" {}
variable "database_username" {}
variable "database_password" {}
variable "database_engine" {}
variable "database_engine_version" {}
variable "database_instance_class" {}
variable "database_sg_id" {}
variable "parameter_groupname" {}

#ec2
variable "project_name" {}
variable "image_id" {}
variable "ec2_instance_type" {}
variable "webserver_sg_id" {}
variable "env" {}
variable "rds_endpoint" {}
variable "database_name" {}
variable "database_username" {}
variable "database_password" {}
variable "record_names" {}