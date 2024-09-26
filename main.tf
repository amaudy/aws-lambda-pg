terraform {
}

provider "aws" {
  region = "us-east-1"
}

# Get the AWS account ID
data "aws_caller_identity" "current" {}

variable "db_password" {
  type        = string
  description = "Database password"
  sensitive   = true
}

module "db_secret" {
  source      = "./modules/secret-manager"
  db_password = var.db_password
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
