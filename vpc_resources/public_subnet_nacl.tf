resource "aws_network_acl" "public_subnet_nacl" {
  vpc_id = aws_vpc.new_vpc.id

  # Allows inbound HTTP traffic from any IPv4 address.
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.full_cidr_block
    from_port  = var.http_port
    to_port    = var.http_port
  }


  # Allows inbound HTTPS traffic from any IPv4 address.
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.full_cidr_block
    from_port  = var.https_port
    to_port    = var.https_port
  }

  /*
    Allows inbound return traffic from hosts on the internet 
    that are responding to requests originating in the subnet.
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

  # Allows outbound responses to clients on the internet
  egress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = var.full_cidr_block
    from_port  = var.ephemeral_port_1024
    to_port    = var.ephemeral_port_65535
  }

  subnet_ids = [
    aws_subnet.public_subnet_a.id,
    aws_subnet.public_subnet_b.id
  ]

  tags = {
    Name = format("%s_public_subnet_nacl", var.project_name)
  }
}
