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

module "database" {
  source       = "./modules/database"
  db_password  = var.db_password
  vpc_id       = module.networks.vpc_id
  subnet_ids   = module.networks.subnet_ids
  lambda_sg_id = module.pingdb_lambda.lambda_sg_id
}

module "get_secret_lambda" {
  source      = "./modules/get-secret"
  secret_arn  = module.db_secret.secret_arn
  secret_name = "rds/postgresql/db_password"
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

# Output the database information
output "db_instance_endpoint" {
  value       = module.database.db_instance_endpoint
  description = "The connection endpoint for the database"
}

output "db_instance_name" {
  value       = module.database.db_instance_name
  description = "The name of the database"
}

output "db_instance_username" {
  value       = module.database.db_instance_username
  description = "The master username for the database"
}

module "pingdb_lambda" {
  source      = "./modules/pingdb"
  db_host     = split(":", module.database.db_instance_endpoint)[0]
  db_name     = module.database.db_instance_name
  db_user     = module.database.db_instance_username
  secret_name = module.db_secret.secret_name
  secret_arn  = module.db_secret.secret_arn
  vpc_id      = module.networks.vpc_id
  subnet_ids  = module.networks.subnet_ids
}

output "pingdb_lambda_arn" {
  value       = module.pingdb_lambda.lambda_arn
  description = "The ARN of the pingdb Lambda function"
}
