// # define the hihghest number of subnets
// variable "max_subnets" {}

# define the ami for wordpress to be used
variable "ami-web" {}

# Instance profile fom module network
variable "instance_profile" {}

# state the public key
variable "keypair" {}

# define the ami for wordpress to be used
variable "ami-bastion" {}

# the security group for webservers
variable "web-sg" {}

# the security group for bastion
variable "bastion-sg" {}

# the security group for nginx
variable "nginx-sg" {}

# the security private nginx
variable "private_subnets-1" {}

# the security private nginx
variable "private_subnets-2" {}

# the first public subnets in the module network output 
variable "public_subnets-1" {}


# the second public subnets in the module network output 
variable "public_subnets-2" {}


# the ami to be used for nginx reverse proxy
variable "ami-nginx" {}

# the target group for nginx form module ALB
variable "nginx-alb-tgt" {}

# the target group for wordpress form module ALB
variable "wordpress-alb-tgt" {}


# the target group for tooling form module ALB
variable "tooling-alb-tgt" {}

variable "template_az" {}