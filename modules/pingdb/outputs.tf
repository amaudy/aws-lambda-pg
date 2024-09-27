output "lambda_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.pingdb.arn
}

output "lambda_sg_id" {
  description = "The ID of the Lambda function's security group"
  value       = aws_security_group.lambda_sg.id
}