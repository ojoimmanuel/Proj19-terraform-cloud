#--- root/variables.tf---
# values for db-password, db-username, region, vpc_cidr, account no have been specified int the terraform 
# cloud console as a variable

# you can add your own password or update the terrafrom cloud to do so

variable "region" {}

variable "vpc_cidr" {}

variable "db-password" {}

variable "db-username" {}

variable "enable_dns_support" {
  default = "true"
}

variable "enable_dns_hostnames" {
  default = "true"
}

variable "enable_classiclink" {
  default = "false"
}

variable "enable_classiclink_dns_support" {
  default = "false"
}

variable "account_no" {}

variable "keypair" {}

variable "ami-web" {}

variable "ami-bastion" {}

variable "ami-nginx" {}

