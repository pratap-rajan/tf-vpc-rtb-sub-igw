provider "aws" {
  #region = "${var.region}"
  region = var.region
}

terraform {
  backend "s3" {
    bucket = "tf-demo-tfstate-2906"
    key    = "infra-tfstate/terraform.tfstate"
    region = "eu-west-1"
    #dynamodb_table = "tf-demo-db-table"
  }
}

