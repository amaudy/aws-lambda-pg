terraform {
}

provider "aws" {
  region = "us-east-1"
}

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
