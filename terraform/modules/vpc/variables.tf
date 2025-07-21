variable "vpc_id" {
  description = "VPC ID to import (opcional)"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "Public subnet IDs to import (opcional)"
  type        = list(string)
  default     = []
}

variable "private_subnet_ids" {
  description = "Private subnet IDs to import (opcional)"
  type        = list(string)
  default     = []
}