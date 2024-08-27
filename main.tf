resource "aws_security_group" "default" {
  count       = var.enable_security_group && length(var.sg_ids) < 1 ? 1 : 0
  name        = format("%s-sg", module.labels.id)
  vpc_id      = var.vpc_id
  description = var.description
  tags        = module.labels.tags
  lifecycle {
    create_before_destroy = true
  }
}

#tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group_rule" "egress" {
  count             = (var.enable_security_group == true && length(var.sg_ids) < 1 && var.is_external == false && var.egress_rule == true) ? 1 : 0
  description       = var.sg_egress_description
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = join("", aws_security_group.default[*].id)
}
#tfsec:ignore:aws-ec2-no-public-egress-sgr
resource "aws_security_group_rule" "egress_ipv6" {
  count             = (var.enable_security_group == true && length(var.sg_ids) < 1 && var.is_external == false) && var.egress_rule == true ? 1 : 0
  description       = var.sg_egress_ipv6_description
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = join("", aws_security_group.default[*].id)
}
resource "aws_security_group_rule" "ingress" {
  count             = length(var.allowed_ip) > 0 == true && length(var.sg_ids) < 1 ? length(compact(var.allowed_ports)) : 0
  description       = var.sg_ingress_description
  type              = "ingress"
  from_port         = element(var.allowed_ports, count.index)
  to_port           = element(var.allowed_ports, count.index)
  protocol          = var.protocol
  cidr_blocks       = var.allowed_ip
  security_group_id = join("", aws_security_group.default[*].id)
}

data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}
data "aws_iam_policy_document" "default" {
  version = "2012-10-17"
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        format(
          "arn:%s:iam::%s:root",
          join("", data.aws_partition.current[*].partition),
          data.aws_caller_identity.current.account_id
        )
      ]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }
}

resource "aws_cloudwatch_log_group" "default" {
  name              = "elasticache-${var.name}"
  retention_in_days = var.retention_in_days
  tags              = module.labels.tags
}


resource "aws_elasticache_subnet_group" "default" {
  name        = var.name
  subnet_ids  = var.subnet_ids
  description = var.subnet_group_description
  tags        = module.labels.tags
}

resource "random_password" "auth_token" {
  count   = var.auth_token_enable && var.auth_token == null ? 1 : 0
  length  = var.length
  special = var.special
}

resource "aws_elasticache_replication_group" "cluster" {
  count                      = var.cluster_replication_enabled ? 1 : 0
  engine                     = var.engine
  replication_group_id       = module.labels.id
  description                = var.replication_group_description
  engine_version             = var.engine_version
  port                       = var.port
  parameter_group_name       = var.parameter_group_name
  node_type                  = var.node_type
  automatic_failover_enabled = var.automatic_failover_enabled
  subnet_group_name          = join("", aws_elasticache_subnet_group.default[*].name)
  security_group_ids         = length(var.sg_ids) < 1 ? aws_security_group.default[*].id : var.sg_ids
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
  transit_encryption_enabled =
  multi_az_enabled           = var.multi_az_enabled
  auth_token                 = var.auth_token_enable ? (var.auth_token == null ? random_password.auth_token[0].result : var.auth_token) : null
  tags                       = module.labels.tags
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

resource "aws_elasticache_cluster" "default" {
  engine                       = var.engine
  cluster_id                   = module.labels.id
  engine_version               = var.engine_version
  port                         = var.port
  num_cache_nodes              = var.num_cache_nodes
  az_mode                      = var.az_mode
  parameter_group_name         = var.parameter_group_name
  node_type                    = var.node_type
  subnet_group_name            = join("", aws_elasticache_subnet_group.default[*].name)
  security_group_ids           = length(var.sg_ids) < 1 ? aws_security_group.default[*].id : var.sg_ids
  snapshot_arns                = var.snapshot_arns
  snapshot_name                = var.snapshot_name
  notification_topic_arn       = var.notification_topic_arn
  snapshot_window              = var.snapshot_window
  snapshot_retention_limit     = var.snapshot_retention_limit
  apply_immediately            = var.apply_immediately
  preferred_availability_zones = slice(var.availability_zones, 0, var.num_cache_nodes)
  maintenance_window           = var.maintenance_window
  tags                         = module.labels.tags

}

# resource "aws_ssm_parameter" "secret" {
#   count       = var.auth_token_enable ? 1 : 0
#   name        = format("/%s/%s/auth-token", var.environment, var.name)
#   description = var.ssm_parameter_description
#   type        = var.ssm_parameter_type
#   value       = var.auth_token == null ? random_password.auth_token[0].result : var.auth_token
#   key_id      = var.kms_key_id == "" ? join("", aws_kms_key.default[*].arn) : var.kms_key_id
# }

# resource "aws_ssm_parameter" "secret-endpoint" {
#   count       = var.enable && var.ssm_parameter_endpoint_enabled ? 1 : 0
#   name        = format("/%s/%s/endpoint", var.environment, var.name)
#   description = var.ssm_parameter_description
#   type        = var.ssm_parameter_type
#   value       = var.automatic_failover_enabled ? [join("", aws_elasticache_replication_group.cluster[*].configuration_endpoint_address)][0] : [join("", aws_elasticache_replication_group.cluster[*].primary_endpoint_address)][0]
#   key_id      = var.kms_key_id == "" ? join("", aws_kms_key.default[*].arn) : var.kms_key_id
# }
