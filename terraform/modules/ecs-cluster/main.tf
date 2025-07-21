# ECS Cluster Module

# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = "disabled"
  }

  lifecycle {
    prevent_destroy = false
  }
}

# User data script for ECS instances
locals {
  user_data = base64encode(<<-EOF
    #!/bin/bash
    echo ECS_CLUSTER=${var.cluster_name} >> /etc/ecs/ecs.config
    sudo dd if=/dev/zero of=/swapfile bs=128M count=32
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    sudo echo "/swapfile swap swap defaults 0 0" >> /etc/fstab
    yum update -y
    yum install -y ecs-init
    service docker start
    start ecs
  EOF
  )
}

# Launch Template for ECS Instances
resource "aws_launch_template" "ecs" {
  name_prefix   = "ECSLaunchTemplate_"
  image_id      = "ami-01cbd8cecccfed7dd" # ECS-optimized AMI
  instance_type = "t3.micro"
  key_name      = var.key_name

  iam_instance_profile {
    arn = var.instance_profile_arn
  }

  user_data = local.user_data

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination       = true
    device_index                = 0
    security_groups             = [var.security_group_id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name     = "ECS Instance - ${var.cluster_name}"
      BIA-PROD = "true"
    }
  }

  lifecycle {
    prevent_destroy = false
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "ecs" {
  name                = "${var.cluster_name}-asg"
  vpc_zone_identifier = var.subnet_ids
  min_size            = 1
  max_size            = 4
  desired_capacity    = 1
  health_check_type   = "EC2"

  launch_template {
    id      = aws_launch_template.ecs.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "ECS Instance - ${var.cluster_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = ""
    propagate_at_launch = true
  }

  lifecycle {
    prevent_destroy = false
  }
}

# ECS Capacity Provider
resource "aws_ecs_capacity_provider" "main" {
  name = "${var.cluster_name}-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs.arn
    managed_termination_protection = "DISABLED"
    managed_draining               = "ENABLED"

    managed_scaling {
      status                    = "ENABLED"
      target_capacity           = 100
      minimum_scaling_step_size = 1
      maximum_scaling_step_size = 10000
      instance_warmup_period    = 300
    }
  }
}

# Associate Capacity Provider with Cluster
resource "aws_ecs_cluster_capacity_providers" "main" {
  cluster_name = aws_ecs_cluster.main.name

  capacity_providers = [aws_ecs_capacity_provider.main.name]

  default_capacity_provider_strategy {
    base              = 0
    weight            = 1
    capacity_provider = aws_ecs_capacity_provider.main.name
  }

  lifecycle {
    prevent_destroy = false
  }
}
