# CloudWatch Module

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = var.log_group_name
  retention_in_days = 7

  tags = {
    Name        = var.log_group_name
    Environment = "production"
    Project     = "bia"
    BIA-PROD    = "true"
  }
}