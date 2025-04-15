# create an s3 bucket 
resource "aws_s3_bucket" "env_file_bucket" {
  bucket = "${var.bucket_nmae}"

  lifecycle {
    create_before_destroy = false
  }
}