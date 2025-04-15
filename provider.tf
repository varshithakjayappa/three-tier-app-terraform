terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 5.93.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      environment = var.env
    }
  }
}