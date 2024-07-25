terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 4.25.0"
        }
    }
    required_version = ">= 1.1.0"
}

provider "aws" {
    profile = var.aws_profile
    region  = "us-east-1"
}




