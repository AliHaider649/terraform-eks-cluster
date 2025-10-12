terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-alihaider"
    key            = "envs/prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.16.0"
    }
  }
}


provider "aws" {
  region = var.region
}