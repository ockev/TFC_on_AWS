provider "aws" {
    region = var.region
}


terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "koconnor"

    workspaces {
      name = "TFC_on_AWS_Prod"
    }
  }
}




# #storing state in s3
# terraform {
#   backend "s3" {
#     bucket = "kevin-terraform-backend"
#     key    = "state/default.tfstate"
#     region = "us-east-1"
#   }
# }