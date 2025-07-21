# Variables for BIA ECS Infrastructure

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "ECS cluster name"
  type        = string
  default     = "cluster-bia-ecs"
}

variable "service_name" {
  description = "ECS service name"
  type        = string
  default     = "service-bia"
}

variable "task_definition_family" {
  description = "Task definition family name"
  type        = string
  default     = "task-asg-bia"
}

variable "container_name" {
  description = "Container name"
  type        = string
  default     = "bia"
}

variable "container_cpu" {
  description = "Container CPU units"
  type        = number
  default     = 1024
}

variable "container_memory_reservation" {
  description = "Container memory reservation in MB"
  type        = number
  default     = 307
}

variable "container_port" {
  description = "Container port"
  type        = number
  default     = 8080
}

variable "ecr_repository_url" {
  description = "ECR repository URL (external, not managed by Terraform)"
  type        = string
  default     = "194722426008.dkr.ecr.us-east-1.amazonaws.com/bia"
}

variable "log_group_name" {
  description = "CloudWatch log group name"
  type        = string
  default     = "/ecs/task-asg-bia"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = "vpc-0698571b371f90ffd"
}

variable "subnet_ids" {
  description = "Public subnet IDs (for ALB)"
  type        = list(string)
  default     = [
    "subnet-0b43acb43748f2bfa",  # us-east-1a public
    "subnet-05b490de4d22ebb2d",  # us-east-1c public
    "subnet-0fb1b408083e751e5"   # us-east-1f public
  ]
}

variable "private_subnet_ids" {
  description = "Private subnet IDs (for ECS instances and RDS)"
  type        = list(string)
  default     = [
    "subnet-0b81d9426bad42502",  # us-east-1a private
    "subnet-0a1505bcf0fa5f440",  # us-east-1c private
    "subnet-0ce4f23c228a65581"   # us-east-1f private
  ]
}

variable "key_name" {
  description = "EC2 Key Pair name"
  type        = string
  default     = "nholanda"
}

variable "environment_variables" {
  description = "Environment variables for the container"
  type = list(object({
    name  = string
    value = string
  }))
  default = [
    {
      name  = "DB_PWD"
      value = "rdms95gn"
    },
    {
      name  = "DB_HOST"
      value = "bia.cx4q6caas2ti.us-east-1.rds.amazonaws.com"
    },
    {
      name  = "DB_PORT"
      value = "5432"
    },
    {
      name  = "DB_USER"
      value = "postgres"
    }
  ]
}