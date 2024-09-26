variable "db_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "The IDs of the subnets"
  type        = list(string)
}