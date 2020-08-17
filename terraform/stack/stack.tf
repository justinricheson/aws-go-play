terraform {
  required_version = ">= 0.12"
  backend "s3" {
    region         = "us-east-1"
    bucket         = "terraform-790055257995"
    key            = "aws-go-play/stack/stack.tfstate"
    dynamodb_table = "terraform-lock"
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  type = string
}

resource "aws_s3_bucket" "tmp_bucket" {
  bucket = "tmp-bucket-790055257995"
  acl    = "private"
}
