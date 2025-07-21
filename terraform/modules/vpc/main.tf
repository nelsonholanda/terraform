# VPC Module - Import existing VPC and subnets

# Import existing VPC
resource "aws_vpc" "main" {
  cidr_block           = "172.16.0.0/20"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "NHolanda-VPC"
    Environment = "production"
    Project     = "bia"
    BIA-PROD    = "true"
  }

  lifecycle {
    prevent_destroy = false
  }
}

# Import existing public subnets
resource "aws_subnet" "public_1a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.16.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name     = "NHolanda-VPC-subnet-public1-us-east-1a"
    BIA-PROD = "true"
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_subnet" "public_1c" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.16.1.0/24"
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = true

  tags = {
    Name     = "NHolanda-VPC-subnet-public2-us-east-1c"
    BIA-PROD = "true"
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_subnet" "public_1f" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "172.16.2.0/24"
  availability_zone       = "us-east-1f"
  map_public_ip_on_launch = true

  tags = {
    Name     = "NHolanda-VPC-subnet-public3-us-east-1f"
    BIA-PROD = "true"
  }

  lifecycle {
    prevent_destroy = false
  }
}

# Import existing private subnets
resource "aws_subnet" "private_1a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "172.16.8.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name     = "NHolanda-VPC-subnet-private1-us-east-1a"
    BIA-PROD = "true"
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_subnet" "private_1c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "172.16.9.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name     = "NHolanda-VPC-subnet-private2-us-east-1c"
    BIA-PROD = "true"
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_subnet" "private_1f" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-east-1f"

  tags = {
    Name     = "NHolanda-VPC-subnet-private3-us-east-1f"
    BIA-PROD = "true"
  }

  lifecycle {
    prevent_destroy = false
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "NHolanda-VPC-igw"
    Environment = "production"
    Project     = "bia"
    BIA-PROD    = "true"
  }
}

# Route table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name        = "NHolanda-VPC-public-rt"
    Environment = "production"
    Project     = "bia"
    BIA-PROD    = "true"
  }
}

# Route table associations for public subnets
resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_1c" {
  subnet_id      = aws_subnet.public_1c.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_1f" {
  subnet_id      = aws_subnet.public_1f.id
  route_table_id = aws_route_table.public.id
}

# Route table for private subnets (default route table)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "NHolanda-VPC-private-rt"
    Environment = "production"
    Project     = "bia"
    BIA-PROD    = "true"
  }
}

# Route table associations for private subnets
resource "aws_route_table_association" "private_1a" {
  subnet_id      = aws_subnet.private_1a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_1c" {
  subnet_id      = aws_subnet.private_1c.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_1f" {
  subnet_id      = aws_subnet.private_1f.id
  route_table_id = aws_route_table.private.id
}