terraform {
  backend "s3" {
    bucket = "cea-project-dynamic-app"
    key    = "terraform.tfstate"
    region = "eu-central-1"
    profile = "terrraform-user"
  }
}