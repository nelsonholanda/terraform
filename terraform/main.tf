# Main Terraform configuration for BIA ECS Infrastructure
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  backend "s3" {
    bucket = "tf-nh"
    key    = "kiro-tf-bia/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
}

# Data sources for existing resources
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# VPC Module - não precisa mais de parâmetros pois está criando recursos novos
module "vpc" {
  source = "./modules/vpc"
}

# IAM Module
module "iam" {
  source = "./modules/iam"

  cluster_name = var.cluster_name
}

# Security Groups Module
module "security_groups" {
  source = "./modules/security-groups"

  vpc_id       = module.vpc.vpc_id
  cluster_name = var.cluster_name
}

# CloudWatch Module
module "cloudwatch" {
  source = "./modules/cloudwatch"

  log_group_name = var.log_group_name
}

# RDS Module
module "rds" {
  source = "./modules/rds"

  db_identifier      = "bia"
  security_group_ids = [module.security_groups.bia_rds_sg_id]
  subnet_ids         = module.vpc.private_subnet_ids
}

# ALB Module
module "alb" {
  source = "./modules/alb"

  alb_name           = "alb-bia"
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.subnet_ids
  security_group_ids = [module.security_groups.bia_alb_sg_id]
}

# ECS Cluster Module
module "ecs_cluster" {
  source = "./modules/ecs-cluster"

  cluster_name         = var.cluster_name
  vpc_id               = module.vpc.vpc_id
  subnet_ids           = module.vpc.subnet_ids
  security_group_id    = module.security_groups.ecs_security_group_id
  instance_profile_arn = module.iam.ecs_instance_profile_arn
  key_name             = var.key_name
}

# ECS Service Module
module "ecs_service" {
  source = "./modules/ecs-service"

  cluster_id                   = module.ecs_cluster.cluster_id
  cluster_name                 = var.cluster_name
  service_name                 = var.service_name
  task_definition_family       = var.task_definition_family
  container_name               = var.container_name
  container_image              = var.ecr_repository_url
  container_cpu                = var.container_cpu
  container_memory_reservation = var.container_memory_reservation
  container_port               = var.container_port
  log_group_name               = module.cloudwatch.log_group_name
  task_execution_role_arn      = module.iam.ecs_task_execution_role_arn
  capacity_provider_name       = module.ecs_cluster.capacity_provider_name
  target_group_arn             = module.alb.target_group_arn

  environment_variables = var.environment_variables
}
