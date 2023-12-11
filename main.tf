terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "random" {}

provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket = "tfstate-ee03fdccbeb4bf4177b97d1c3289b2ab06089789"
    key    = "tfsandbox.tfstate"
    region = "us-west-2"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-*-x86_64-ebs"]
  }
}

resource "random_pet" "my_pet" {
    length = 2
}

resource "aws_vpc" "example_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = random_pet.my_pet.id  
  }
}

resource "aws_vpc_dhcp_options" "example_dhcp_options" {
  domain_name = "local"
  tags = {
    Name = random_pet.my_pet.id  
  }
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = aws_vpc.example_vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.example_dhcp_options.id
}

resource "aws_subnet" "example_subnet" {
  vpc_id     = aws_vpc.example_vpc.id
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = random_pet.my_pet.id  
  }
}

resource "aws_instance" "example_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.example_subnet.id
  tags = { 
    Name = random_pet.my_pet.id  
  }
}