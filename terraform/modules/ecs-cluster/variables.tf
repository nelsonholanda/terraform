variable "cluster_name" {
  description = "ECS cluster name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for ECS instances"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID for ECS instances"
  type        = string
}

variable "instance_profile_arn" {
  description = "IAM instance profile ARN"
  type        = string
}

variable "key_name" {
  description = "EC2 Key Pair name"
  type        = string
}