# The backend depends on the terraform remote cloud
# terraform {
#   backend "remote" {
#     hostname     = "app.terraform.io"
#     organization = "pisitis"

#     workspaces {
#       name = "AWS_CLOUD_INFRASTRUCTURE"
#     }
#   }
# }