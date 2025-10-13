output "id" {
  value       = module.redis-cluster.id
  description = "Redis cluster id."
}


output "redis_endpoint" {
  value       = module.redis-cluster[*].redis_endpoint
  description = "Redis endpoint address."
}