terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket = "moveoterrabe"
    key    = "terraform.tfstate"
    region = "il-central-1"
  }
  required_version = "~> 1.12.0"
}
provider "aws" {
  region = "il-central-1"
}