variable "name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `cluster`)."
}

variable "description" {
  type        = string
  default     = "The Description of the ElastiCache Subnet Group."
  description = "Description for the cache subnet group. Defaults to `Managed by Terraform`."
}


variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)."
}

variable "automatic_failover_enabled" {
  type        = bool
  default     = true
  description = "Specifies whether a read-only replica will be automatically promoted to read/write primary if the existing primary fails. If true, Multi-AZ is enabled for this replication group. If false, Multi-AZ is disabled for this replication group. Must be enabled for Redis (cluster mode enabled) replication groups. Defaults to false."
}

variable "engine_version" {
  type        = string
  default     = "7.1"
  description = "The version number of the cache engine to be used for the cache clusters in this replication group."
}

variable "node_type" {
  type        = string
  default     = "cache.t2.small"
  description = "The compute and memory capacity of the nodes in the node group."
}

variable "security_group_names" {
  type        = list(string)
  default     = null
  description = "A list of cache security group names to associate with this replication group."
}

variable "snapshot_arns" {
  type        = list(string)
  default     = null
  description = "A single-element string list containing an Amazon Resource Name (ARN) of a Redis RDB snapshot file stored in Amazon S3."
}

variable "snapshot_name" {
  type        = string
  default     = ""
  description = "The name of a snapshot from which to restore data into the new node group. Changing the snapshot_name forces a new resource."
  sensitive   = true
}

variable "snapshot_window" {
  type        = string
  default     = null
  description = "(Redis only) The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. The minimum snapshot window is a 60 minute period."
}

variable "snapshot_retention_limit" {
  type        = string
  default     = "0"
  description = "(Redis only) The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. For example, if you set SnapshotRetentionLimit to 5, then a snapshot that was taken today will be retained for 5 days before being deleted. If the value of SnapshotRetentionLimit is set to zero (0), backups are turned off. Please note that setting a snapshot_retention_limit is not supported on cache.t1.micro or cache.t2.* cache nodes."
}

variable "notification_topic_arn" {
  type        = string
  default     = ""
  description = "An Amazon Resource Name (ARN) of an SNS topic to send ElastiCache notifications to."
  sensitive   = true
}

variable "apply_immediately" {
  type        = bool
  default     = false
  description = "Specifies whether any modifications are applied immediately, or during the next maintenance window. Default is false."
}

variable "subnet_ids" {
  type        = list(any)
  default     = []
  description = "List of VPC Subnet IDs for the cache subnet group."
  sensitive   = true
}


variable "replication_group_description" {
  type        = string
  default     = "User-created description for the replication group."
  description = "Name of either the CloudWatch Logs LogGroup or Kinesis Data Firehose resource."
}

variable "availability_zones" {
  type        = list(string)
  description = "A list of EC2 availability zones in which the replication group's cache clusters will be created. The order of the availability zones in the list is not important."
}

variable "num_cache_clusters" {
  type        = number
  default     = 1
  description = "(Required for Cluster Mode Disabled) The number of cache clusters (primary and replicas) this replication group will have. If Multi-AZ is enabled, the value of this parameter must be at least 2. Updates will occur before other modifications."
}

variable "auto_minor_version_upgrade" {
  type        = bool
  default     = true
  description = "Specifies whether a minor engine upgrades will be applied automatically to the underlying Cache Cluster instances during the maintenance window. Defaults to true."
}

variable "maintenance_window" {
  type        = string
  default     = "sun:05:00-sun:06:00"
  description = "Maintenance window."
}

variable "auth_token_enabled" {
  type        = bool
  default     = true
  description = "Flag to specify whether to create auth token (password) protected cluster. Can be specified only if transit_encryption_enabled = true."
}

variable "auth_token" {
  type        = string
  default     = null
  description = "The password used to access a password protected server. Can be specified only if transit_encryption_enabled = true."
}

variable "cluster_replication_enabled" {
  type        = bool
  default     = false
  description = "(Redis only) Enabled or disabled replication_group for redis cluster."
}

variable "num_cache_nodes" {
  type        = number
  default     = 1
  description = "(Required unless replication_group_id is provided) The initial number of cache nodes that the cache cluster will have. For Redis, this value must be 1. For Memcache, this value must be between 1 and 20. If this number is reduced on subsequent runs, the highest numbered nodes will be removed."
}

variable "log_delivery_configuration" {
  type        = list(map(any))
  default     = []
  description = "The log_delivery_configuration block allows the streaming of Redis SLOWLOG or Redis Engine Log to CloudWatch Logs or Kinesis Data Firehose. Max of 2 blocks."
}

variable "retention_in_days" {
  type        = number
  default     = 0
  description = "Specifies the number of days you want to retain log events in the specified log group."
}

variable "multi_az_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether to enable Multi-AZ Support for the replication group. If true, automatic_failover_enabled must also be enabled. Defaults to false."
}

variable "deletion_window_in_days" {
  type        = number
  default     = 7
  description = "Duration in days after which the key is deleted after destruction of the resource."
}

variable "vpc_id" {
  type        = string
  default     = ""
  description = "The ID of the VPC that the instance security group belongs to."
  sensitive   = true
}


variable "security_group_ids" {
  type        = list(any)
  default     = []
  description = "of the security group id."
}


###------------------------------- random_password----------------------------
variable "length" {
  type    = number
  default = 25
}

variable "special" {
  type    = bool
  default = false
}
