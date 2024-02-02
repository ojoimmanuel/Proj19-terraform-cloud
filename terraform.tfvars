# name = "emydevops"

region = "us-east-1"

vpc_cidr = "172.16.0.0/16"

enable_dns_support = "true"

enable_dns_hostnames = "true"

enable_classiclink = "false"

enable_classiclink_dns_support = "false"

ami-web = "ami-06c888dc2a4c07b62"

ami-bastion = "ami-05fd468b24f02c7ad"

ami-nginx = "ami-0eaa4c6b745bc2dfd"

keypair = "ec2-key"

db-username = "emydevops"

db-password = "proj17pbl"

account_no = 635977375707

# master-username = "emydevops"

# master-password = "proj17pbl"



# preferred_number_of_public_subnets = 2

# preferred_number_of_private_subnets = 4

# tags = {
#   Environment     = "emy-devops"
#   Owner-Email     = "ojoiimmanuel@gmail.com"
#   Managed-By      = "Terraform"
#   Billing-Account = "1234567890"
# }