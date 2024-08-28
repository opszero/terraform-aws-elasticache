output "id" {
  value       = aws_elasticache_replication_group.cluster[*].id
  description = "Redis cluster id."
}

output "port" {
  value       = var.port
  sensitive   = true
  description = "Redis port."
}

output "redis_endpoint" {
  value       = aws_elasticache_replication_group.cluster[*].primary_endpoint_address
  description = "Redis endpoint address."
}

output "redis_arn" {
  value       = length(aws_elasticache_replication_group.cluster) > 0 ? aws_elasticache_replication_group.cluster[0].arn : length(aws_elasticache_replication_group.cluster) > 0 ? aws_elasticache_replication_group.cluster[0].arn : ""
  description = "Redis arn"
}

output "sg_id" {
  value = aws_security_group.default[*].id
}

# output "redis_ssm_name" {
#   value       = aws_ssm_parameter.secret-endpoint[*].name
#   description = "A list of all of the parameter values"
# }

# output "auth_token" {
#   value       = random_password.auth_token[0].result
#   sensitive   = true
#   description = "Auth token generated value"
# }
