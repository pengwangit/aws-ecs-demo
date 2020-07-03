output "vpc_id" {
  value = aws_vpc.new_vpc.id
}

output "public_subnet_a_id" {
  value = aws_subnet.public_subnet_a.id
}

output "public_subnet_b_id" {
  value = aws_subnet.public_subnet_b.id
}

output "private_subnet_a_ecs_id" {
  value = aws_subnet.private_subnet_a_ecs.id
}

output "private_subnet_b_ecs_id" {
  value = aws_subnet.private_subnet_b_ecs.id
}

output "private_subnet_a_rds_id" {
  value = aws_subnet.private_subnet_a_rds.id
}

output "private_subnet_b_rds_id" {
  value = aws_subnet.private_subnet_b_rds.id
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}

output "ecs_instance_ec2_sg_id" {
  value = aws_security_group.ecs_instance_ec2_sg.id
}

output "availability_zones" {
  value = var.availability_zones
}

output "http_port" {
  value = var.http_port
}
