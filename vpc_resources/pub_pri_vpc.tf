# 1. create VPC
resource "aws_vpc" "new_vpc" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = format("%s_vpc", var.project_name)
  }
}

# 2 . Public Subnets

resource "aws_subnet" "public_subnet_a" {
  vpc_id                  = aws_vpc.new_vpc.id
  cidr_block              = var.public_subnet_a_cidr
  map_public_ip_on_launch = true
  availability_zone       = element(var.availability_zones, 0)
  tags = {
    Name = format("%s_public_subnet_a", var.project_name)
  }
}

resource "aws_subnet" "public_subnet_b" {
  vpc_id                  = aws_vpc.new_vpc.id
  cidr_block              = var.public_subnet_b_cidr
  map_public_ip_on_launch = true
  availability_zone       = element(var.availability_zones, 1)
  tags = {
    Name = format("%s_public_subnet_b", var.project_name)
  }
}

# 3. create Private Subnets

resource "aws_subnet" "private_subnet_a_ecs" {
  vpc_id            = aws_vpc.new_vpc.id
  cidr_block        = var.private_subnet_a_ecs
  availability_zone = element(var.availability_zones, 0)
  tags = {
    Name = format("%s_private_subnet_a_ecs", var.project_name)
  }
}

resource "aws_subnet" "private_subnet_b_ecs" {
  vpc_id            = aws_vpc.new_vpc.id
  cidr_block        = var.private_subnet_b_ecs
  availability_zone = element(var.availability_zones, 1)
  tags = {
    Name = format("%s_private_subnet_b_ecs", var.project_name)
  }
}

resource "aws_subnet" "private_subnet_a_rds" {
  vpc_id            = aws_vpc.new_vpc.id
  cidr_block        = var.private_subnet_a_rds
  availability_zone = element(var.availability_zones, 0)
  tags = {
    Name = format("%s_private_subnet_a_rds", var.project_name)
  }
}

resource "aws_subnet" "private_subnet_b_rds" {
  vpc_id            = aws_vpc.new_vpc.id
  cidr_block        = var.private_subnet_b_rds
  availability_zone = element(var.availability_zones, 1)
  tags = {
    Name = format("%s_private_subnet_b_rds", var.project_name)
  }
}

# 4. create internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.new_vpc.id

  tags = {
    Name = format("%s_igw", var.project_name)
  }
}

# 5. create Elastic IP for NAT gateway
resource "aws_eip" "nat_eip_a" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = format("%s_nat_eip_a", var.project_name)
  }
}

resource "aws_eip" "nat_eip_b" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = format("%s_nat_eip_b", var.project_name)
  }
}

# 6. create NAT gateway for all servers
resource "aws_nat_gateway" "nat_a" {
  allocation_id = aws_eip.nat_eip_a.id
  subnet_id     = aws_subnet.public_subnet_a.id
  depends_on    = [aws_internet_gateway.igw]

  tags = {
    Name = format("%s_nat_a", var.project_name)
  }
}

resource "aws_nat_gateway" "nat_b" {
  allocation_id = aws_eip.nat_eip_b.id
  subnet_id     = aws_subnet.public_subnet_b.id
  depends_on    = [aws_internet_gateway.igw]

  tags = {
    Name = format("%s_nat_b", var.project_name)
  }
}

# 7. create route table for public subnets
resource "aws_route_table" "route_table_pub" {
  vpc_id = aws_vpc.new_vpc.id

  route {
    cidr_block = var.full_cidr_block
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = format("%s_route_table_pub", var.project_name)
  }
}

# 8 create route table for private subnets 

resource "aws_route_table" "route_table_pri_a" {
  vpc_id = aws_vpc.new_vpc.id

  route {
    cidr_block     = var.full_cidr_block
    nat_gateway_id = aws_nat_gateway.nat_a.id
  }

  tags = {
    Name = format("%s_route_table_pri_a", var.project_name)
  }
}

resource "aws_route_table" "route_table_pri_b" {
  vpc_id = aws_vpc.new_vpc.id

  route {
    cidr_block     = var.full_cidr_block
    nat_gateway_id = aws_nat_gateway.nat_b.id
  }

  tags = {
    Name = format("%s_route_table_pri_b", var.project_name)
  }
}

# 9 create route table association for public subnets

resource "aws_route_table_association" "public_subnet_a" {
  subnet_id      = aws_subnet.public_subnet_a.id
  route_table_id = aws_route_table.route_table_pub.id
}

resource "aws_route_table_association" "public_subnet_b" {
  subnet_id      = aws_subnet.public_subnet_b.id
  route_table_id = aws_route_table.route_table_pub.id
}

# 10 create route table association for private subnets

resource "aws_route_table_association" "private_subnet_a_ecs_rta" {
  subnet_id      = aws_subnet.private_subnet_a_ecs.id
  route_table_id = aws_route_table.route_table_pri_a.id
}

resource "aws_route_table_association" "private_subnet_b_ecs_rta" {
  subnet_id      = aws_subnet.private_subnet_b_ecs.id
  route_table_id = aws_route_table.route_table_pri_b.id
}

resource "aws_route_table_association" "private_subnet_a_rds_rta" {
  subnet_id      = aws_subnet.private_subnet_a_rds.id
  route_table_id = aws_route_table.route_table_pri_a.id
}

resource "aws_route_table_association" "private_subnet_b_rds_rta" {
  subnet_id      = aws_subnet.private_subnet_b_rds.id
  route_table_id = aws_route_table.route_table_pri_b.id
}
