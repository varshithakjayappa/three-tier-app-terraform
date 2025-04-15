locals {
  region = var.aws_region
  project_name = var.project_name
  environment = var.env
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.9"
    }
  }
}

provider "aws" {
 region = var.aws_region
 profile = "terraform-user"
}

#create s3 module
module "s3_bucket" {
  source = "./terraform/s3"
  bucket_nmae = var.bucket_name
}

#create vpc modules
module "vpc" {
  source = "./terraform/vpc"
  region = local.region
  project_name = local.project_name
  environment = local.environment
  vpc_cidr                     = var.vpc_cidr
  public_subnet_az1_cidr       = var.public_subnet_az1_cidr
  public_subnet_az2_cidr       = var.public_subnet_az2_cidr
  private_app_subnet_az1_cidr  = var.private_app_subnet_az1_cidr
  private_app_subnet_az2_cidr  = var.private_app_subnet_az2_cidr
  private_data_subnet_az1_cidr = var.private_data_subnet_az1_cidr
  private_data_subnet_az2_cidr = var.private_data_subnet_az2_cidr
  availability_zone_1a = var.availability_zone_1a
  availability_zone_1b = var.availability_zone_1b
}

#create security groups
module "security_groups" {
  source = "./terraform/security_groups"
  project_name = local.project_name
  vpc_id = var.vpc_id
}

#create rds modules
module "rds" {
  source = "./terraform/rds"
  project_name = var.project_name
  database_name = var.database_name
  database_username = var.database_username
  database_password = var.database_password
  database_engine = var.database_engine
  database_engine_version = var.database_engine_version
  database_instance_class = var.database_instance_class
  database_sg_id = var.database_sg_id
  parameter_groupname = var.parameter_groupname
}

#ec2 module
module "ec2" {
  source = "./terraform/launch-configuration"
  project_name = var.project_name
  image_id = var.image_id
  ec2_instance_type = var.ec2_instance_type
  webserver_sg_id = var.webserver_sg_id
  env = var.env
  rds_endpoint = var.rds_endpoint
  database_name = var.database_name
  database_username = var.database_username
  database_password = var.database_password
  record_names = var.record_names
}

#asg
module "asg" {
  source = "./terraform/asg"
  project_name = var.project_name
  private_app_subnet_az1_id = var.private_app_subnet_az1_id
  private_app_subnet_az2_id = var.private_app_subnet_az2_id
  aws_launch_template-webserver_launch_template = var.aws_launch_template-webserver_launch_template
  aws_lb_target_group = var.aws_lb_target_group
}

#alb
module "alb" {
  source = "./terraform/alb"
  project_name = var.project_name
  public_subnet_az1_cidr = var.public_subnet_az1_cidr
  public_subnet_az2_cidr = var.public_subnet_az2_cidr
  alb_security_group_id = var.alb_security_group_id
  vpc_id = var.vpc_id
  certificate_arn = var.certificate_arn
}

#acm module
module "acm" {
 source = "./terraform/acm"
 domain_name = var.domain_name
}

