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
  default     = "cache.t3.small"
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

variable "transit_encryption_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether to enable encryption in transit."
}

variable "replication_group_description" {
  type        = string
  default     = null
  description = "Desc of either the  resource."
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

variable "num_cache_nodes" {
  type        = number
  default     = 1
  description = "(Required unless replication_group_id is provided) The initial number of cache nodes that the cache cluster will have. For Redis, this value must be 1. For Memcache, this value must be between 1 and 20. If this number is reduced on subsequent runs, the highest numbered nodes will be removed."
}

variable "log_delivery_configuration" {
  description = "(Redis OSS or Valkey) Specifies the destination and format of Redis OSS/Valkey SLOWLOG or Redis OSS/Valkey Engine Log"
  type        = any
  default = {
    slow-log = {
      destination_type = "cloudwatch-logs"
      log_format       = "json"
    }
  }
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

variable "parameter_group_parameters" {
  description = "A list of parameter maps to apply"
  type        = list(map(string))
  default     = []
}

variable "parameter_group_family" {
  description = "The engine version that the parameter group can be used with"
  type        = string
  default     = "redis7"
}

variable "replication_group_id" {
  description = "Replication group identifier. When `create_replication_group` is set to `true`, this is the ID assigned to the replication group created. When `create_replication_group` is set to `false`, this is the ID of an externally created replication group"
  type        = string
  default     = null
}

variable "availability_zone" {
  description = "Availability Zone for the cache cluster. If you want to create cache nodes in multi-az, use `preferred_availability_zones` instead"
  type        = string
  default     = null
}

variable "final_snapshot_identifier" {
  description = "(Redis only) Name of your final cluster snapshot. If omitted, no final snapshot will be made"
  type        = string
  default     = null
}

variable "ip_discovery" {
  description = "The IP version to advertise in the discovery protocol. Valid values are `ipv4` or `ipv6`"
  type        = string
  default     = null
}

variable "az_mode" {
  description = "Whether the nodes in this Memcached node group are created in a single Availability Zone or created across multiple Availability Zones in the cluster's region. Valid values for this parameter are `single-az` or `cross-az`, default is `single-az`"
  type        = string
  default     = null
}

variable "network_type" {
  description = "The IP versions for cache cluster connections. Valid values are `ipv4`, `ipv6` or `dual_stack`"
  type        = string
  default     = null
}

variable "outpost_mode" {
  description = "Specify the outpost mode that will apply to the cache cluster creation. Valid values are `single-outpost` and `cross-outpost`, however AWS currently only supports `single-outpost` mode"
  type        = string
  default     = null
}

variable "preferred_availability_zones" {
  description = "List of the Availability Zones in which cache nodes are created"
  type        = list(string)
  default     = []
}

variable "preferred_outpost_arn" {
  description = "(Required if `outpost_mode` is specified) The outpost ARN in which the cache cluster will be created"
  type        = string
  default     = null
}

variable "create_replication_group" {
  description = "Determines whether an ElastiCache replication group will be created or not"
  type        = bool
  default     = true
}

variable "timeouts" {
  description = "Define maximum timeout for creating, updating, and deleting cluster resource"
  type        = map(string)
  default     = {}
}


variable "engine" {
  description = "ElastiCache engine type to use. Valid values: 'redis', 'valkey', or 'memcached'."
  type        = string
  default     = ""
}

variable "port" {
  description = "The port number on which the cache engine accepts connections. Default is 11211 for Memcached and 6379 for Redis."
  type        = number
  default     = 11211
}
