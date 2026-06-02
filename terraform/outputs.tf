output "ec2_instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.app_server.public_ip
}

output "ec2_instance_public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = aws_instance.app_server.public_dns
}

output "rds_endpoint" {
  description = "Endpoint address of the RDS PostgreSQL instance"
  value       = aws_db_instance.database.endpoint
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket created for backups/storage"
  value       = aws_s3_bucket.storage_bucket.id
}

output "lambda_function_arn" {
  description = "ARN of the AWS Lambda function"
  value       = aws_lambda_function.process_function.arn
}
