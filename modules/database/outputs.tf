output "db_instance_endpoint" {
  description = "The connection endpoint for the database"
  value       = aws_db_instance.products.endpoint
}

output "db_instance_name" {
  description = "The name of the database"
  value       = aws_db_instance.products.db_name
}

output "db_instance_username" {
  description = "The master username for the database"
  value       = aws_db_instance.products.username
}