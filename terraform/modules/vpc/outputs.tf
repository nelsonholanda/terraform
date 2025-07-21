output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "subnet_ids" {
  description = "Public subnet IDs"
  value       = [
    aws_subnet.public_1a.id,
    aws_subnet.public_1c.id,
    aws_subnet.public_1f.id
  ]
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = [
    aws_subnet.private_1a.id,
    aws_subnet.private_1c.id,
    aws_subnet.private_1f.id
  ]
}