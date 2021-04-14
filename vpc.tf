resource "aws_vpc" "my_demo_app" {

  #count            = "${terraform.workspace == "dev" ? 0 : 1}"
  cidr_block       = "${var.vpc_cidr}"
  instance_tenancy = "default"

  tags = {
    Name = "Terraform-Demo-App"
    #To provide - dynamic workspace name - Also creates separate tfstate file
    Environment = "${terraform.workspace}"
    Team        = "DevOps"
    HSN         = "TF-DEMO-DEV-2"
  }

}
