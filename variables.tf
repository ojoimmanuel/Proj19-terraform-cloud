variable "name" {
  type    = string
  default = "emydevops"
}

variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "172.16.0.0/16"
}


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

variable "preferred_number_of_public_subnets" {
  default = 2
}

variable "preferred_number_of_private_subnets" {
  default = 4
}

variable "tags" {
  description = "A mapping of tags to assign to all resources."
  type        = map(string)
  default     = {}
}

variable "ami" {
  type        = string
  description = "AMI for launch templates"
}

variable "keypair" {
  type        = string
  description = "keypair for instance"
}

variable "account_no" {
  type        = number
  description = "the account no"
}

variable "master-username" {
  type        = string
  description = "rds master username"
}

variable "master-password" {
  type        = string
  description = "rds master password"
}