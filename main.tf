terraform {
}

provider "aws" {
  region = var.aws_region
}

# Get the AWS account ID
data "aws_caller_identity" "current" {}

variable "aws_region" {
  type        = string
  description = "The AWS region to use"
}

variable "db_password" {
  type        = string
  description = "Database password"
  sensitive   = true
}

module "networks" {
  source     = "./modules/networks"
  aws_region = var.aws_region
}

module "db_secret" {
  source      = "./modules/secret-manager"
  db_password = var.db_password
}

module "get_secret_lambda" {
  source      = "./modules/get-secret"
  secret_arn  = module.db_secret.secret_arn
  secret_name = "rds/postgresql/db_password"
#   vpc_id      = module.networks.vpc_id
#   subnet_ids  = module.networks.subnet_ids
}

# Output the AWS account ID
output "account_id" {
  value       = data.aws_caller_identity.current.account_id
  description = "The AWS Account ID"
}

# Output the VPC and subnet information
output "vpc_id" {
  value       = module.networks.vpc_id
  description = "The ID of the default VPC"
}

output "subnet_ids" {
  value       = module.networks.subnet_ids
  description = "The IDs of the subnets in the default VPC"
}
