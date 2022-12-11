terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.13"
    }
  }

  required_version = ">= 1.1.8"
}

provider "aws" {
  region  = "us-east-1"
}

resource "aws_ecr_repository" "reader" {
  name = "reader"
}

resource "aws_ecr_repository" "reader_ui" {
  name = "reader_ui"
}
