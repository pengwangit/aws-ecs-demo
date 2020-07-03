resource "aws_network_acl" "private_subnet_rds_nacl" {
  vpc_id = aws_vpc.new_vpc.id

  # Allow psql port 5432 traffic from ecs private subnets

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.private_subnet_a_ecs
    from_port  = var.psql_port
    to_port    = var.psql_port
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 101
    action     = "allow"
    cidr_block = var.private_subnet_b_ecs
    from_port  = var.psql_port
    to_port    = var.psql_port
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = var.full_cidr_block
    from_port  = var.ephemeral_port_1024
    to_port    = var.ephemeral_port_65535
  }

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.full_cidr_block
    from_port  = var.http_port
    to_port    = var.http_port
  }

  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.full_cidr_block
    from_port  = var.https_port
    to_port    = var.https_port
  }

  # Allow outbound traffic to ecs private subnets

  egress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = var.private_subnet_a_ecs
    from_port  = var.ephemeral_port_32768
    to_port    = var.ephemeral_port_65535
  }

  egress {
    protocol   = "tcp"
    rule_no    = 301
    action     = "allow"
    cidr_block = var.private_subnet_b_ecs
    from_port  = var.ephemeral_port_32768
    to_port    = var.ephemeral_port_65535
  }

  subnet_ids = [
    aws_subnet.private_subnet_a_rds.id,
    aws_subnet.private_subnet_b_rds.id
  ]

  tags = {
    Name = format("%s_private_subnet_rds_nacl", var.project_name)
  }
}
