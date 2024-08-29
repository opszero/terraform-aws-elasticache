output "id" {
  value       = aws_elasticache_replication_group.cluster[*].id
  description = "Redis cluster id."
}

output "redis_endpoint" {
  value       = aws_elasticache_replication_group.cluster[*].primary_endpoint_address
  description = "Redis endpoint address."
}

output "redis_arn" {
  value       = aws_elasticache_replication_group.cluster.arn
  description = "Redis arn"
}
