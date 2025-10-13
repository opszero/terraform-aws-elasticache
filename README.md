# Terraform-aws-elasticache

# Terraform AWS Cloud elasticache Module

## Table of Contents
- [Introduction](#introduction)
- [Usage](#usage)
- [Examples](#Examples)
- [Author](#Author)
- [License](#license)
- [Inputs](#inputs)
- [Outputs](#outputs)

## Introduction
This Terraform module creates an AWS elasticache along with additional configuration options.

## Usage
To use this module, you can include it in your Terraform configuration. Here's an example of how to use it:

## Examples:

## Example: memcached

```hcl
module "memcached" {
  source                     = "git::https://github.com/opszero/terraform-aws-elasticache.git?ref=v1.0.1"
  name                       = "memcached"
  engine                     = "memcached"
  engine_version             = "1.6.17"
  node_type                  = "cache.t2.micro"
  num_cache_nodes            = 2
  subnet_ids                 = module.subnets.public_subnet_id
  automatic_failover_enabled = false
  security_group_ids         = []
  security_group_names       = null
}
```

## Example: redis

```hcl
module "redis" {
  source                        = "git::https://github.com/opszero/terraform-aws-elasticache.git?ref=v1.0.1"
  name                          = "redis"
  engine                        = "redis"
  engine_version                = "7.0"
  port                          = 6379
  node_type                     = "cache.r6g.large"
  subnet_ids                    = module.subnets.public_subnet_id
  automatic_failover_enabled    = false
  multi_az_enabled              = false
  num_cache_clusters            = 1
  retention_in_days             = 0
  snapshot_retention_limit      = 7
  replication_group_description = "opszero"

  log_delivery_configuration = [
    {
      destination_type = "cloudwatch-logs"
      log_format       = "json"
      log_type         = "slow-log"
    },
    {
      destination_type = "cloudwatch-logs"
      log_format       = "json"
      log_type         = "engine-log"
    }
  ]
}
```

## Example: redis-cluster
```hcl
module "redis-cluster" {
  source                        = "git::https://github.com/opszero/terraform-aws-elasticache.git?ref=v1.0.1"
  name                          = "redis-cluster"
  engine                        = "redis"
  engine_version                = "7.0"
  port                          = 6379
  node_type                     = "cache.t2.micro"
  subnet_ids                    = module.subnets.public_subnet_id
  num_cache_nodes               = 1
  snapshot_retention_limit      = 7
  automatic_failover_enabled    = false
  replication_group_description = "opszero"

  log_delivery_configuration = [
    {
      destination_type = "cloudwatch-logs"
      log_format       = "json"
      log_type         = "slow-log"
    },
    {
      destination_type = "cloudwatch-logs"
      log_format       = "json"
      log_type         = "engine-log"
    }
  ]
}
```

## Examples
For detailed examples on how to use this module, please refer to the [Examples](https://github.com/opszero/terraform-aws-elasticache/tree/master/example) directory within this repository.

## Author
Your Name Replace **MIT** and **opszero** with the appropriate license and your information. Feel free to expand this README with additional details or usage instructions as needed for your specific use case.

## License
This project is licensed under the **MIT** License - see the [LICENSE](https://github.com/opszero/terraform-aws-elasticache/blob/master/LICENSE) file for details.

<!-- BEGIN_TF_DOCS -->

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.14.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.7.2 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Specifies whether any modifications are applied immediately, or during the next maintenance window. Default is false. | `bool` | `false` | no |
| <a name="input_auth_token"></a> [auth\_token](#input\_auth\_token) | The password used to access a password protected server. Can be specified only if transit\_encryption\_enabled = true. | `string` | `null` | no |
| <a name="input_auth_token_enabled"></a> [auth\_token\_enabled](#input\_auth\_token\_enabled) | Flag to specify whether to create auth token (password) protected cluster. Can be specified only if transit\_encryption\_enabled = true. | `bool` | `true` | no |
| <a name="input_auto_minor_version_upgrade"></a> [auto\_minor\_version\_upgrade](#input\_auto\_minor\_version\_upgrade) | Specifies whether a minor engine upgrades will be applied automatically to the underlying Cache Cluster instances during the maintenance window. Defaults to true. | `bool` | `true` | no |
| <a name="input_automatic_failover_enabled"></a> [automatic\_failover\_enabled](#input\_automatic\_failover\_enabled) | Specifies whether a read-only replica will be automatically promoted to read/write primary if the existing primary fails. If true, Multi-AZ is enabled for this replication group. If false, Multi-AZ is disabled for this replication group. Must be enabled for Redis (cluster mode enabled) replication groups. Defaults to false. | `bool` | `true` | no |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | Availability Zone for the cache cluster. If you want to create cache nodes in multi-az, use `preferred_availability_zones` instead | `string` | `null` | no |
| <a name="input_az_mode"></a> [az\_mode](#input\_az\_mode) | Whether the nodes in this Memcached node group are created in a single Availability Zone or created across multiple Availability Zones in the cluster's region. Valid values for this parameter are `single-az` or `cross-az`, default is `single-az` | `string` | `null` | no |
| <a name="input_create_replication_group"></a> [create\_replication\_group](#input\_create\_replication\_group) | Determines whether an ElastiCache replication group will be created or not | `bool` | `true` | no |
| <a name="input_deletion_window_in_days"></a> [deletion\_window\_in\_days](#input\_deletion\_window\_in\_days) | Duration in days after which the key is deleted after destruction of the resource. | `number` | `7` | no |
| <a name="input_description"></a> [description](#input\_description) | Description for the cache subnet group. Defaults to `Managed by Terraform`. | `string` | `"The Description of the ElastiCache Subnet Group."` | no |
| <a name="input_engine"></a> [engine](#input\_engine) | ElastiCache engine type to use. Valid values: 'redis', 'valkey', or 'memcached'. | `string` | `""` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | The version number of the cache engine to be used for the cache clusters in this replication group. | `string` | `"7.1"` | no |
| <a name="input_final_snapshot_identifier"></a> [final\_snapshot\_identifier](#input\_final\_snapshot\_identifier) | (Redis only) Name of your final cluster snapshot. If omitted, no final snapshot will be made | `string` | `null` | no |
| <a name="input_ip_discovery"></a> [ip\_discovery](#input\_ip\_discovery) | The IP version to advertise in the discovery protocol. Valid values are `ipv4` or `ipv6` | `string` | `null` | no |
| <a name="input_length"></a> [length](#input\_length) | ##------------------------------- random\_password---------------------------- | `number` | `25` | no |
| <a name="input_log_delivery_configuration"></a> [log\_delivery\_configuration](#input\_log\_delivery\_configuration) | (Redis OSS or Valkey) Specifies the destination and format of Redis OSS/Valkey SLOWLOG or Redis OSS/Valkey Engine Log | `any` | <pre>{<br>  "slow-log": {<br>    "destination_type": "cloudwatch-logs",<br>    "log_format": "json"<br>  }<br>}</pre> | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Maintenance window. | `string` | `"sun:05:00-sun:06:00"` | no |
| <a name="input_multi_az_enabled"></a> [multi\_az\_enabled](#input\_multi\_az\_enabled) | Specifies whether to enable Multi-AZ Support for the replication group. If true, automatic\_failover\_enabled must also be enabled. Defaults to false. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| <a name="input_network_type"></a> [network\_type](#input\_network\_type) | The IP versions for cache cluster connections. Valid values are `ipv4`, `ipv6` or `dual_stack` | `string` | `null` | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | The compute and memory capacity of the nodes in the node group. | `string` | `"cache.t3.small"` | no |
| <a name="input_notification_topic_arn"></a> [notification\_topic\_arn](#input\_notification\_topic\_arn) | An Amazon Resource Name (ARN) of an SNS topic to send ElastiCache notifications to. | `string` | `""` | no |
| <a name="input_num_cache_clusters"></a> [num\_cache\_clusters](#input\_num\_cache\_clusters) | (Required for Cluster Mode Disabled) The number of cache clusters (primary and replicas) this replication group will have. If Multi-AZ is enabled, the value of this parameter must be at least 2. Updates will occur before other modifications. | `number` | `1` | no |
| <a name="input_num_cache_nodes"></a> [num\_cache\_nodes](#input\_num\_cache\_nodes) | (Required unless replication\_group\_id is provided) The initial number of cache nodes that the cache cluster will have. For Redis, this value must be 1. For Memcache, this value must be between 1 and 20. If this number is reduced on subsequent runs, the highest numbered nodes will be removed. | `number` | `1` | no |
| <a name="input_outpost_mode"></a> [outpost\_mode](#input\_outpost\_mode) | Specify the outpost mode that will apply to the cache cluster creation. Valid values are `single-outpost` and `cross-outpost`, however AWS currently only supports `single-outpost` mode | `string` | `null` | no |
| <a name="input_parameter_group_family"></a> [parameter\_group\_family](#input\_parameter\_group\_family) | The engine version that the parameter group can be used with | `string` | `"redis7"` | no |
| <a name="input_parameter_group_parameters"></a> [parameter\_group\_parameters](#input\_parameter\_group\_parameters) | A list of parameter maps to apply | `list(map(string))` | `[]` | no |
| <a name="input_port"></a> [port](#input\_port) | The port number on which the cache engine accepts connections. Default is 11211 for Memcached and 6379 for Redis. | `number` | `11211` | no |
| <a name="input_preferred_availability_zones"></a> [preferred\_availability\_zones](#input\_preferred\_availability\_zones) | List of the Availability Zones in which cache nodes are created | `list(string)` | `[]` | no |
| <a name="input_preferred_outpost_arn"></a> [preferred\_outpost\_arn](#input\_preferred\_outpost\_arn) | (Required if `outpost_mode` is specified) The outpost ARN in which the cache cluster will be created | `string` | `null` | no |
| <a name="input_replication_group_description"></a> [replication\_group\_description](#input\_replication\_group\_description) | Desc of either the  resource. | `string` | `null` | no |
| <a name="input_replication_group_id"></a> [replication\_group\_id](#input\_replication\_group\_id) | Replication group identifier. When `create_replication_group` is set to `true`, this is the ID assigned to the replication group created. When `create_replication_group` is set to `false`, this is the ID of an externally created replication group | `string` | `null` | no |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | Specifies the number of days you want to retain log events in the specified log group. | `number` | `0` | no |
| <a name="input_security_group_ids"></a> [security\_group\_ids](#input\_security\_group\_ids) | of the security group id. | `list(any)` | `[]` | no |
| <a name="input_security_group_names"></a> [security\_group\_names](#input\_security\_group\_names) | A list of cache security group names to associate with this replication group. | `list(string)` | `null` | no |
| <a name="input_snapshot_arns"></a> [snapshot\_arns](#input\_snapshot\_arns) | A single-element string list containing an Amazon Resource Name (ARN) of a Redis RDB snapshot file stored in Amazon S3. | `list(string)` | `null` | no |
| <a name="input_snapshot_name"></a> [snapshot\_name](#input\_snapshot\_name) | The name of a snapshot from which to restore data into the new node group. Changing the snapshot\_name forces a new resource. | `string` | `""` | no |
| <a name="input_snapshot_retention_limit"></a> [snapshot\_retention\_limit](#input\_snapshot\_retention\_limit) | (Redis only) The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. For example, if you set SnapshotRetentionLimit to 5, then a snapshot that was taken today will be retained for 5 days before being deleted. If the value of SnapshotRetentionLimit is set to zero (0), backups are turned off. Please note that setting a snapshot\_retention\_limit is not supported on cache.t1.micro or cache.t2.* cache nodes. | `string` | `"0"` | no |
| <a name="input_snapshot_window"></a> [snapshot\_window](#input\_snapshot\_window) | (Redis only) The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. The minimum snapshot window is a 60 minute period. | `string` | `null` | no |
| <a name="input_special"></a> [special](#input\_special) | n/a | `bool` | `false` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of VPC Subnet IDs for the cache subnet group. | `list(any)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. map(`BusinessUnit`,`XYZ`). | `map(string)` | `{}` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | Define maximum timeout for creating, updating, and deleting cluster resource | `map(string)` | `{}` | no |
| <a name="input_transit_encryption_enabled"></a> [transit\_encryption\_enabled](#input\_transit\_encryption\_enabled) | Specifies whether to enable encryption in transit. | `bool` | `false` | no |
## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_elasticache_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster) | resource |
| [aws_elasticache_parameter_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_parameter_group) | resource |
| [aws_elasticache_replication_group.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_kms_key.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [random_password.auth_token](https://registry.terraform.io/providers/hashicorp/random/3.7.2/docs/resources/password) | resource |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | Redis cluster id. |
| <a name="output_redis_arn"></a> [redis\_arn](#output\_redis\_arn) | n/a |
| <a name="output_redis_endpoint"></a> [redis\_endpoint](#output\_redis\_endpoint) | Redis endpoint address. |
# 🚀 Built by opsZero!

<a href="https://opszero.com"><img src="https://opszero.com/wp-content/uploads/2024/07/opsZero_logo_svg.svg" width="300px"/></a>

Since 2016 [opsZero](https://opszero.com) has been providing Kubernetes
expertise to companies of all sizes on any Cloud. With a focus on AI and
Compliance we can say we seen it all whether SOC2, HIPAA, PCI-DSS, ITAR,
FedRAMP, CMMC we have you and your customers covered.

We provide support to organizations in the following ways:

- [Modernize or Migrate to Kubernetes](https://opszero.com/solutions/modernization/)
- [Cloud Infrastructure with Kubernetes on AWS, Azure, Google Cloud, or Bare Metal](https://opszero.com/solutions/cloud-infrastructure/)
- [Building AI and Data Pipelines on Kubernetes](https://opszero.com/solutions/ai/)
- [Optimizing Existing Kubernetes Workloads](https://opszero.com/solutions/optimized-workloads/)

We do this with a high-touch support model where you:

- Get access to us on Slack, Microsoft Teams or Email
- Get 24/7 coverage of your infrastructure
- Get an accelerated migration to Kubernetes

Please [schedule a call](https://calendly.com/opszero-llc/discovery) if you need support.

<br/><br/>

<div style="display: block">
  <img src="https://opszero.com/wp-content/uploads/2024/07/aws-advanced.png" width="150px" />
  <img src="https://opszero.com/wp-content/uploads/2024/07/AWS-public-sector.png" width="150px" />
  <img src="https://opszero.com/wp-content/uploads/2024/07/AWS-eks.png" width="150px" />
</div>
<!-- END_TF_DOCS -->
