terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.27.0"
    }
    local = {
      source = "hashicorp/local"
      version = "2.6.1"
    }
    tls = {
      source = "hashicorp/tls"
      version = "4.1.0"
    }    
  }
}

provider "aws" {
  region = "ap-southeast-1"
  profile = "default"
}