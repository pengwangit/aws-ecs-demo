resource "aws_network_acl" "private_subnet_ecs_nacl" {
  vpc_id = aws_vpc.new_vpc.id

  # Allow http 80 traffic from public subnets

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.public_subnet_a_cidr
    from_port  = var.http_port
    to_port    = var.http_port
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 101
    action     = "allow"
    cidr_block = var.public_subnet_b_cidr
    from_port  = var.http_port
    to_port    = var.http_port
  }

  /* 
     Allows inbound return traffic from the NAT device in the public subnet 
     for requests originating in the private subnet.
  */

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

  egress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = var.public_subnet_a_cidr
    from_port  = var.ephemeral_port_32768
    to_port    = var.ephemeral_port_65535
  }

  egress {
    protocol   = "tcp"
    rule_no    = 301
    action     = "allow"
    cidr_block = var.public_subnet_b_cidr
    from_port  = var.ephemeral_port_32768
    to_port    = var.ephemeral_port_65535
  }

  # Allows outbound psql request to RDS in private subnets on

  egress {
    protocol   = "tcp"
    rule_no    = 302
    action     = "allow"
    cidr_block = var.private_subnet_a_rds
    from_port  = var.psql_port
    to_port    = var.psql_port
  }

  egress {
    protocol   = "tcp"
    rule_no    = 303
    action     = "allow"
    cidr_block = var.private_subnet_b_rds
    from_port  = var.psql_port
    to_port    = var.psql_port
  }

  subnet_ids = [
    aws_subnet.private_subnet_a_ecs.id,
    aws_subnet.private_subnet_b_ecs.id
  ]

  tags = {
    Name = format("%s_private_subnet_ecs_nacl", var.project_name)
  }
}
