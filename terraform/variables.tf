variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name to be used as prefix for resources"
  type        = string
  default     = "aws-drawio-flow"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "ec2_instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "db_instance_class" {
  description = "RDS DB instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "flowdb"
}

variable "db_username" {
  description = "Database admin username"
  type        = string
  default     = "dbadmin"
  sensitive   = true
}
