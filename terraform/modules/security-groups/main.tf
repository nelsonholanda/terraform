# Security Groups Module

# Security Group for ECS Development
resource "aws_security_group" "bia_dev" {
  name        = "bia-dev"
  description = "Security group for BIA development environment"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name     = "bia-dev"
    BIA-PROD = "true"
  }
}

# Security Group for RDS
resource "aws_security_group" "bia_rds" {
  name        = "bia-rds"
  description = "Security group for BIA RDS database"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.bia_ec2.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name     = "bia-rds"
    BIA-PROD = "true"
  }
}

# Security Group for ALB
resource "aws_security_group" "bia_alb" {
  name        = "bia-alb"
  description = "Security group for BIA Application Load Balancer"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name     = "bia-alb"
    BIA-PROD = "true"
  }
}

# Security Group for EC2 instances
resource "aws_security_group" "bia_ec2" {
  name        = "bia-ec2"
  description = "Security group for BIA EC2 instances"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 32768
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.bia_alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name     = "bia-ec2"
    BIA-PROD = "true"
  }
}