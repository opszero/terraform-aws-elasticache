resource "aws_cloudwatch_log_group" "default" {
  name              = "${var.name}-elasticache"
  retention_in_days = var.retention_in_days
  tags              = var.tags
}


resource "aws_elasticache_subnet_group" "default" {
  name        = var.name
  subnet_ids  = var.subnet_ids
  description = var.description
  tags        = var.tags
}

resource "random_password" "auth_token" {
  count   = var.auth_token_enabled && var.auth_token == null ? 1 : 0
  length  = var.length
  special = var.special
}

resource "aws_elasticache_replication_group" "cluster" {
  engine                     = "redis"
  replication_group_id       = var.name
  description                = var.replication_group_description
  engine_version             = var.engine_version
  parameter_group_name       = aws_elasticache_parameter_group.default.id
  node_type                  = var.node_type
  automatic_failover_enabled = var.automatic_failover_enabled
  subnet_group_name          = aws_elasticache_subnet_group.default.name
  security_group_ids         = var.security_group_ids
  security_group_names       = var.security_group_names
  snapshot_arns              = var.snapshot_arns
  snapshot_name              = var.snapshot_name
  notification_topic_arn     = var.notification_topic_arn
  snapshot_window            = var.snapshot_window
  snapshot_retention_limit   = var.snapshot_retention_limit
  apply_immediately          = var.apply_immediately
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  maintenance_window         = var.maintenance_window
  at_rest_encryption_enabled = true
  transit_encryption_enabled = var.transit_encryption_enabled
  multi_az_enabled           = var.multi_az_enabled
  auth_token                 = var.auth_token_enabled ? (var.auth_token == null ? random_password.auth_token[0].result : var.auth_token) : null
  tags                       = var.tags
  num_cache_clusters         = var.num_cache_clusters

  dynamic "log_delivery_configuration" {
    for_each = var.log_delivery_configuration

    content {
      destination      = lookup(log_delivery_configuration.value, "destination", join("", aws_cloudwatch_log_group.default[*].name))
      destination_type = lookup(log_delivery_configuration.value, "destination_type", null)
      log_format       = lookup(log_delivery_configuration.value, "log_format", null)
      log_type         = lookup(log_delivery_configuration.value, "log_type", null)
    }
  }
}

resource "aws_elasticache_parameter_group" "default" {
  name   = var.name
  family = var.parameter_group_family
  dynamic "parameter" {
    for_each = var.parameter_group_parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }
  lifecycle {
      create_before_destroy = true
    }
}


# resource "aws_ssm_parameter" "password" {
#   name        = format("/elasticache/auth-token", var.environment, var.name)
#   description = var.ssm_parameter_description
#   type        = var.ssm_parameter_type
#   value       = var.auth_token == null ? random_password.auth_token[0].result : var.auth_token
# }
