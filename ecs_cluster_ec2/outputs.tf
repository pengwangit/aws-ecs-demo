output "ecs_dns_name" {
  value = aws_alb.ecs_alb.dns_name
}
output "ecs_target_group_arn" {
  value = aws_alb_target_group.ecs_target_group.arn
}

output "ecs_cluster_id" {
  value = aws_ecs_cluster.ecs_cluster.id
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.ecs_cluster.name
}
