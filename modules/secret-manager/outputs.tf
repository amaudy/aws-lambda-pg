output "secret_arn" {
  description = "The ARN of the Secrets Manager secret"
  value       = aws_secretsmanager_secret.db_password.arn
}

output "secret_name" {
  description = "The name of the Secrets Manager secret"
  value       = aws_secretsmanager_secret.db_password.name
}