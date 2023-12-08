terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example_server" {
  ami           = "ami-093467ec28ae4fe03"
  instance_type = "t2.micro"
  subnet_id     = "subnet-5eaa0807"
  tags = {
    Name = "BlahBlah"
  }
}