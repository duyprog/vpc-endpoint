terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.0.0"
    }
  }

  backend "s3" {
    bucket = "ghc-devops-terraform-backend"
    key = "key"
    region = "ap-southeast-1"
    encrypt = true
    dynamodb_table = "terraform-locks-table"
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

locals {
  system_code = "ghc-devops"
  env         = "development"
  env_code    = "dev"
  owner       = "duypk5"
}

module "vpc" {
  source         = "./modules/vpc"
  system_code    = local.system_code
  env            = local.env
  env_code       = local.env_code
  owner          = local.owner
  vpc_cidr_block = "10.0.0.0/16"
}

module "ec2" {
  source    = "./modules/ec2"
  subnet_id = element(module.vpc.private_subnet_id, 0)
  vpc_id = module.vpc.vpc_id
  vpc_cidr_block = "10.0.0.0/16"
  depends_on = [ module.vpc ]
}

module "vpc_endpoint" {
  source = "./modules/vpc-endpoint"
  region = "ap-southeast-1"
  vpc_id = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnet_id
  cidr_block = "10.0.0.0/16"
}
