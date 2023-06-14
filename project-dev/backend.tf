terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "0.23.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "4.2.0"
    }
  }

  # cloud {
  #   organization = "koconnor"
  #   hostname     = "app.terraform.io"

  #   workspaces {
  #     name = "learn-hcp-packer-run-tasks-data-source-validation"
  #   }
  # }
}





# provider "aws" {
#     region = "us-east-1"
# }


terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "koconnor"

    workspaces {
      name = "TFC_on_AWS_Dev"
    }
  }
}

# # #storing state in s3, allows collaboration, portability; locking also in effect to prevent dupes; really enables ci/cd if setup this way; officially called remote state
# # terraform {
# #   backend "s3" {
# #     bucket = "kevin-terraform-backend-dev"
# #     key    = "state/default-dev.tfstate"
# #     region = "us-east-1"
# #   }
# # }