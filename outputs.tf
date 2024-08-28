output "id" {
  value       = aws_elasticache_replication_group.cluster[*].id
  description = "Redis cluster id."
}

output "redis_endpoint" {
  value       = aws_elasticache_replication_group.cluster[*].primary_endpoint_address
  description = "Redis endpoint address."
}

output "redis_arn" {
  value       = length(aws_elasticache_replication_group.cluster) > 0 ? aws_elasticache_replication_group.cluster[0].arn : length(aws_elasticache_replication_group.cluster) > 0 ? aws_elasticache_replication_group.cluster[0].arn : ""
  description = "Redis arn"
}
