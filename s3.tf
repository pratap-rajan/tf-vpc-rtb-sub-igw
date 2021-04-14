resource "aws_s3_bucket" "app-s3-bucket" {
  bucket = "${var.tf-s3-bucket}"
  acl    = "private"

  tags = {
    Name        = "app-s3-tf-bucket"
    Environment = "${terraform.workspace}"
  }
}
