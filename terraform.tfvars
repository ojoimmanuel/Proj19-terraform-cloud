name = "emydevops"

region = "us-east-1"

vpc_cidr = "172.16.0.0/16"

enable_dns_support = "true"

enable_dns_hostnames = "true"

enable_classiclink = "false"

enable_classiclink_dns_support = "false"

preferred_number_of_public_subnets = 2

preferred_number_of_private_subnets = 4

tags = {
  Environment     = "emy-devops"
  Owner-Email     = "ojoiimmanuel@gmail.com"
  Managed-By      = "Terraform"
  Billing-Account = "1234567890"
}

ami = "ami-03951dc3553ee499f"

keypair = "ec2-key"

account_no = 635977375707

master-username = "emydevops"

master-password = "proj17pbl"
