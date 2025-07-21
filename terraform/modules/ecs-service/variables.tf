variable "cluster_id" {
  description = "ECS cluster ID"
  type        = string
}

variable "service_name" {
  description = "ECS service name"
  type        = string
}

variable "task_definition_family" {
  description = "Task definition family name"
  type        = string
}

variable "container_name" {
  description = "Container name"
  type        = string
}

variable "container_image" {
  description = "Container image URL"
  type        = string
}

variable "container_cpu" {
  description = "Container CPU units"
  type        = number
}

variable "container_memory_reservation" {
  description = "Container memory reservation in MB"
  type        = number
}

variable "container_port" {
  description = "Container port"
  type        = number
}

variable "log_group_name" {
  description = "CloudWatch log group name"
  type        = string
}

variable "task_execution_role_arn" {
  description = "Task execution role ARN"
  type        = string
}

variable "capacity_provider_name" {
  description = "ECS capacity provider name"
  type        = string
}

variable "target_group_arn" {
  description = "ALB target group ARN"
  type        = string
}

variable "environment_variables" {
  description = "Environment variables for the container"
  type = list(object({
    name  = string
    value = string
  }))
}

variable "cluster_name" {
  description = "ECS cluster name (for auto scaling resource ID)"
  type        = string
}

variable "max_capacity" {
  description = "Maximum number of tasks for auto scaling"
  type        = number
  default     = 10
}

variable "min_capacity" {
  description = "Minimum number of tasks for auto scaling"
  type        = number
  default     = 1
}

variable "autoscaling_policy_name" {
  description = "Name of the auto scaling policy"
  type        = string
  default     = "BIA-ASG-IN-OUT"
}

variable "predefined_metric_type" {
  description = "Predefined metric type for target tracking"
  type        = string
  default     = "ECSServiceAverageCPUUtilization"
}

variable "target_value" {
  description = "Target value for the metric"
  type        = number
  default     = 10.0
}