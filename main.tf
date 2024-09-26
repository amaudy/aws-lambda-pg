variable "db_password" {
  type        = string
  description = "Database password"
  sensitive   = true
}

module "db_secret" {
  source      = "./modules/secret-manager"
  db_password = var.db_password
}

