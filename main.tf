# Module for network; This module will create all the neccessary resources for the entire project,
#such as vpc, subnets, gateways and all neccssary things to enable proper connectivity

module "network" {
  source                         = "./modules/network"
  region                         = var.region
  vpc_cidr                       = var.vpc_cidr
  enable_dns_support             = var.enable_dns_support
  enable_dns_hostnames           = var.enable_dns_hostnames
  enable_classiclink             = var.enable_classiclink
  enable_classiclink_dns_support = var.enable_classiclink_dns_support
  max_subnets                    = 10
  public_sn_count                = 2
  private_sn_count               = 4
  private_subnets                = [for i in range(1, 8, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
  public_subnets                 = [for i in range(2, 5, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
  security_groups                = local.security_groups
}



#Module for Application Load balancer, this will create Extenal Load balancer and internal load balancer
module "ALB" {
  source        = "./modules/ALB"
  vpc_id        = module.network.vpc_id
  public-sg     = module.network.ALB-sg
  private-sg    = module.network.IALB-sg
  public-sbn-1  = module.network.public_subnets-1
  public-sbn-2  = module.network.public_subnets-2
  private-sbn-1 = module.network.private_subnets-1
  private-sbn-2 = module.network.private_subnets-2
}


# Module for Autoscaling groups; this module will create all autoscaling groups for bastion,
# nginx, and the webservers.

module "autoscaling" {
  source            = "./modules/autoscaling"
  ami-web           = var.ami-web
  ami-bastion       = var.ami-bastion
  ami-nginx         = var.ami-nginx
  template_az       = var.region
  web-sg            = module.network.web-sg
  bastion-sg        = module.network.bastion-sg
  nginx-sg          = module.network.nginx-sg
  wordpress-alb-tgt = module.ALB.dev-wordpress-tgt
  nginx-alb-tgt     = module.ALB.dev-nginx-tgt
  tooling-alb-tgt   = module.ALB.dev-tooling-tgt
  instance_profile  = module.network.instance_profile
  public_subnets-1  = module.network.public_subnets-1
  public_subnets-2  = module.network.public_subnets-2
  private_subnets-1 = module.network.private_subnets-1
  private_subnets-2 = module.network.private_subnets-2
  keypair           = var.keypair
}

# Module for Elastic Filesystem; this module will creat elastic file system isn the webservers availablity
# zone and allow traffic fro the webservers

module "EFS" {
  source       = "./modules/EFS"
  efs-subnet-1 = module.network.private_subnets-1
  efs-subnet-2 = module.network.private_subnets-2
  efs-sg       = module.network.data-layer
  account_no   = var.account_no
}

# RDS module; this module will create the RDS instance in the private subnet

module "RDS" {
  source          = "./modules/RDS"
  db-password     = var.db-password
  db-username     = var.db-username
  db-sg           = module.network.data-layer
  private_subnets = module.network.private_subnets
}

# # The Module creates instances for jenkins, sonarqube abd jfrog
# module "compute" {
#   source          = "./modules/compute"
#   ami-jenkins     = "ami-0202715be1100998b"
#   ami-sonar       = "ami-0202715be1100998b"
#   ami-jfrog       = "ami-0202715be1100998b"
#   subnets-compute = module.network.public_subnets-1
#   sg-compute      = module.network.ALB-sg
#   keypair         = var.keypair
# }
