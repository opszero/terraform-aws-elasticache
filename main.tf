data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  in_replication_group = var.replication_group_id != null

  security_group_ids = var.security_group_ids
  port               = var.engine == "memcached" ? 11211 : 6379

  tags = merge(var.tags, { terraform-aws-modules = "elasticache" })
}

resource "aws_kms_key" "cloudwatch" {
  description             = "KMS key for CloudWatch log group encryption"
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow CloudWatch Logs"
        Effect = "Allow"
        Principal = {
          Service = "logs.${data.aws_region.current.name}.amazonaws.com"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Resource = "*"
        Condition = {
          ArnEquals = {
            "kms:EncryptionContext:aws:logs:arn" = "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${var.name}-elasticache"
          }
        }
      }
    ]
  })
}

resource "aws_cloudwatch_log_group" "default" {
  name              = "${var.name}-elasticache"
  retention_in_days = var.retention_in_days
  kms_key_id        = aws_kms_key.cloudwatch.arn
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
  count                      = (var.engine == "redis" || var.engine == "valkey") && var.create_replication_group ? 1 : 0
  engine                     = var.engine
  replication_group_id       = var.name
  description                = var.replication_group_description
  engine_version             = var.engine_version
  parameter_group_name       = aws_elasticache_parameter_group.default.name
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

resource "aws_elasticache_cluster" "this" {
  count = var.engine == "memcached" ? 1 : 0

  apply_immediately          = var.apply_immediately
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  availability_zone          = var.availability_zone
  az_mode                    = local.in_replication_group ? null : var.az_mode
  cluster_id                 = lower("${var.name}-cluster")
  engine                     = local.in_replication_group ? null : var.engine
  engine_version             = local.in_replication_group ? null : var.engine_version
  final_snapshot_identifier  = var.final_snapshot_identifier
  ip_discovery               = var.ip_discovery

  dynamic "log_delivery_configuration" {
    for_each = { for k, v in var.log_delivery_configuration : k => v if var.engine != "memcached" && !local.in_replication_group }

    content {
      destination      = try(log_delivery_configuration.value.create_cloudwatch_log_group, true) && log_delivery_configuration.value.destination_type == "cloudwatch-logs" ? aws_cloudwatch_log_group.this[log_delivery_configuration.key].name : log_delivery_configuration.value.destination
      destination_type = log_delivery_configuration.value.destination_type
      log_format       = log_delivery_configuration.value.log_format
      log_type         = try(log_delivery_configuration.value.log_type, log_delivery_configuration.key)
    }
  }

  maintenance_window           = local.in_replication_group ? null : var.maintenance_window
  network_type                 = var.network_type
  node_type                    = local.in_replication_group ? null : var.node_type
  notification_topic_arn       = local.in_replication_group ? null : var.notification_topic_arn
  num_cache_nodes              = local.in_replication_group ? null : var.num_cache_nodes
  outpost_mode                 = var.outpost_mode
  parameter_group_name         = aws_elasticache_parameter_group.default.name
  port                         = local.in_replication_group ? null : coalesce(var.port, local.port)
  preferred_availability_zones = var.preferred_availability_zones
  preferred_outpost_arn        = var.preferred_outpost_arn
  replication_group_id         = (var.engine == "redis" || var.engine == "valkey") && var.create_replication_group ? aws_elasticache_replication_group.cluster[0].id : null
  security_group_ids           = local.in_replication_group ? null : local.security_group_ids
  snapshot_arns                = local.in_replication_group ? null : var.snapshot_arns
  snapshot_name                = local.in_replication_group ? null : var.snapshot_name
  snapshot_retention_limit     = local.in_replication_group ? null : var.snapshot_retention_limit
  snapshot_window              = local.in_replication_group ? null : var.snapshot_window
  subnet_group_name            = local.in_replication_group ? null : aws_elasticache_subnet_group.default.name
  transit_encryption_enabled   = var.engine == "memcached" ? var.transit_encryption_enabled : null

  tags = local.tags

  timeouts {
    create = try(var.timeouts.create, null)
    update = try(var.timeouts.update, null)
    delete = try(var.timeouts.delete, null)
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