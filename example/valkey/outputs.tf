output "id" {
  value       = module.valkey[*].id
  description = "Redis cluster id."
}


output "redis_endpoint" {
  value       = module.valkey.redis_endpoint
  description = "Redis endpoint address."
}


