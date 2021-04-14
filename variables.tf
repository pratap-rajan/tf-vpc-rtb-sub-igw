variable "vpc_cidr" {
  description = "Enter vpc CIDR"
  type        = string
  default     = "10.20.0.0/16"

}

variable "region" {
  description = "Please Choose a Region"
  type        = string
  default     = "eu-west-1"

}

variable "web_ec2_count" {
  description = "Please Choose number of ec2 instances for web"
  type        = string
  default     = "2"

}

variable "web_instance_type" {
  description = "Please Choose an instance type for your stack"
  type        = string
  default     = "t3.micro"
}

# Inside variables - You cannot use terraform Interpolation
variable "tags" {
  type = map
  default = {
    Name = "Web-Server"
  }
}

variable "web-server-ami" {

type = map
default = {
  eu-west-1 = "ami-0d712b3e6e1f798ef"
}

}

variable "tf-s3-bucket" {
  
  default = "my-app-s3-bucket"

}

variable "acm-cert" {
  
  default = "arn:aws:acm-pca:eu-west-1:257599234124:certificate-authority/22684ab6-bbf9-4008-84d7-dc879db4bd12"

}