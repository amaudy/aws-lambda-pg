variable "db_host" {
  description = "The hostname of the RDS instance"
  type        = string
}

variable "db_name" {
  description = "The name of the database"
  type        = string
}

variable "db_user" {
  description = "The username for the database"
  type        = string
}

variable "secret_name" {
  description = "The name of the secret in AWS Secrets Manager"
  type        = string
}

variable "secret_arn" {
  description = "The ARN of the secret in AWS Secrets Manager"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "subnet_ids" {
  description = "The IDs of the subnets"
  type        = list(string)
}