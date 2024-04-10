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
  source        = "cypik/memcached/aws"
  version       = "1.0.0"
  name          = "memcached"
  environment   = "test"
  label_order   = ["name", "environment"]
  vpc_id        = module.vpc.id
  allowed_ip    = [module.vpc.vpc_cidr_block]
  allowed_ports = [11211]

  cluster_enabled                          = true
  memcached_ssm_parameter_endpoint_enabled = true
  memcached_route53_record_enabled         = false
  engine                                   = "memcached"
  engine_version                           = "1.6.17"
  parameter_group_name                     = ""
  az_mode                                  = "cross-az"
  port                                     = 11211
  node_type                                = "cache.t2.micro"
  num_cache_nodes                          = 2
  subnet_ids                               = module.subnets.public_subnet_id
  availability_zones                       = ["eu-west-1a", "eu-west-1b"]
  extra_tags = {
    Application = "cypik"
  }

  route53_record_enabled         = false
  ssm_parameter_endpoint_enabled = false
  dns_record_name                = "prod"
  route53_ttl                    = "300"
  route53_type                   = "CNAME"
  route53_zone_id                = "SERFxxxx6XCsY9Lxxxxx"
}
```

## Example: redis

```hcl
module "redis" {
  source        = "cypik/redis/aws"
  version       ="1.0.0"
  name          = "redis"
  environment   = "test"
  label_order   = ["name", "environment"]
  vpc_id        = module.vpc.id
  allowed_ip    = [module.vpc.vpc_cidr_block]
  allowed_ports = [6379]

  cluster_replication_enablRed = true
  engine                      = "redis"
  engine_version              = "7.0"
  parameter_group_name        = "default.redis7"
  port                        = 6379
  node_type                   = "cache.r6g.large"
  subnet_ids                  = module.subnets.public_subnet_id
  availability_zones          = [""]
  automatic_failover_enabled  = false
  multi_az_enabled            = false
  num_cache_clusters          = 1
  retention_in_days           = 0
  snapshot_retention_limit    = 7

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
  extra_tags = {
    Application = "cypik"
  }

  route53_record_enabled         = false
  ssm_parameter_endpoint_enabled = false
  dns_record_name                = "prod"
  route53_ttl                    = "300"
  route53_type                   = "CNAME"
  route53_zone_id                = "Z017xxxxDLxxx0GH04"
}
```

Example: redis-cluster
```hcl
module "redis-cluster" {
  source        = "cypik/redis-cluster/aws"
  version       = "1.0.0"
  name          = "redis-cluster"
  environment   = "test"
  label_order   = ["environment", "name"]
  vpc_id        = module.vpc.id
  allowed_ip    = [module.vpc.vpc_cidr_block]
  allowed_ports = [6379]

  cluster_replication_enabled = true
  engine                      = "redis"
  engine_version              = "7.0"
  parameter_group_name        = "default.redis7.cluster.on"
  port                        = 6379
  node_type                   = "cache.t2.micro"
  subnet_ids                  = module.subnets.public_subnet_id
  availability_zones          = ["eu-west-1a", "eu-west-1b"]
  num_cache_nodes             = 1
  snapshot_retention_limit    = 7
  automatic_failover_enabled  = true
  extra_tags = {
    Application = "cypik"
  }

  route53_record_enabled         = false
  ssm_parameter_endpoint_enabled = false
  dns_record_name                = "prod"
  route53_ttl                    = "300"
  route53_type                   = "CNAME"
  route53_zone_id                = "SERFxxxx6XCsY9Lxxxxx"
}
```

## Examples
For detailed examples on how to use this module, please refer to the [examples](https://github.com/cypik/terraform-aws-elasticache/tree/master/example) directory within this repository.

## Author
Your Name Replace **MIT** and **Cypik** with the appropriate license and your information. Feel free to expand this README with additional details or usage instructions as needed for your specific use case.

## License
This project is licensed under the **MIT** License - see the [LICENSE](https://github.com/cypik/terraform-aws-elasticache/blob/master/LICENSE) file for details.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.32.1 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.0, < 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.32.1 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 3.0, < 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_labels"></a> [labels](#module\_labels) | cypik/labels/aws | 1.0.1 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_elasticache_cluster.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster) | resource |
| [aws_elasticache_replication_group.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_replication_group) | resource |
| [aws_elasticache_subnet_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_kms_alias.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_route53_record.elasticache](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.memcached_route_53](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.egress_ipv6](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_ssm_parameter.memcached_secret-endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.secret-endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ssm_parameter) | resource |
| [random_password.auth_token](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_partition.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/partition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alias"></a> [alias](#input\_alias) | The display name of the alias. The name must start with the word `alias` followed by a forward slash. | `string` | `"alias/redis"` | no |
| <a name="input_allowed_ip"></a> [allowed\_ip](#input\_allowed\_ip) | List of allowed ip. | `list(any)` | `[]` | no |
| <a name="input_allowed_ports"></a> [allowed\_ports](#input\_allowed\_ports) | List of allowed ingress ports | `list(any)` | `[]` | no |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Specifies whether any modifications are applied immediately, or during the next maintenance window. Default is false. | `bool` | `false` | no |
| <a name="input_at_rest_encryption_enabled"></a> [at\_rest\_encryption\_enabled](#input\_at\_rest\_encryption\_enabled) | Enable encryption at rest. | `bool` | `true` | no |
| <a name="input_auth_token"></a> [auth\_token](#input\_auth\_token) | The password used to access a password protected server. Can be specified only if transit\_encryption\_enabled = true. | `string` | `null` | no |
| <a name="input_auth_token_enable"></a> [auth\_token\_enable](#input\_auth\_token\_enable) | Flag to specify whether to create auth token (password) protected cluster. Can be specified only if transit\_encryption\_enabled = true. | `bool` | `true` | no |
| <a name="input_auto_minor_version_upgrade"></a> [auto\_minor\_version\_upgrade](#input\_auto\_minor\_version\_upgrade) | Specifies whether a minor engine upgrades will be applied automatically to the underlying Cache Cluster instances during the maintenance window. Defaults to true. | `bool` | `true` | no |
| <a name="input_automatic_failover_enabled"></a> [automatic\_failover\_enabled](#input\_automatic\_failover\_enabled) | Specifies whether a read-only replica will be automatically promoted to read/write primary if the existing primary fails. If true, Multi-AZ is enabled for this replication group. If false, Multi-AZ is disabled for this replication group. Must be enabled for Redis (cluster mode enabled) replication groups. Defaults to false. | `bool` | `true` | no |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | A list of EC2 availability zones in which the replication group's cache clusters will be created. The order of the availability zones in the list is not important. | `list(string)` | n/a | yes |
| <a name="input_az_mode"></a> [az\_mode](#input\_az\_mode) | (Memcached only) Specifies whether the nodes in this Memcached node group are created in a single Availability Zone or created across multiple Availability Zones in the cluster's region. Valid values for this parameter are single-az or cross-az, default is single-az. If you want to choose cross-az, num\_cache\_nodes must be greater than 1. | `string` | `"single-az"` | no |
| <a name="input_cluster_enabled"></a> [cluster\_enabled](#input\_cluster\_enabled) | (Memcache only) Enabled or disabled cluster. | `bool` | `false` | no |
| <a name="input_cluster_replication_enabled"></a> [cluster\_replication\_enabled](#input\_cluster\_replication\_enabled) | (Redis only) Enabled or disabled replication\_group for redis cluster. | `bool` | `false` | no |
| <a name="input_customer_master_key_spec"></a> [customer\_master\_key\_spec](#input\_customer\_master\_key\_spec) | Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports. Valid values: SYMMETRIC\_DEFAULT, RSA\_2048, RSA\_3072, RSA\_4096, ECC\_NIST\_P256, ECC\_NIST\_P384, ECC\_NIST\_P521, or ECC\_SECG\_P256K1. Defaults to SYMMETRIC\_DEFAULT. | `string` | `"SYMMETRIC_DEFAULT"` | no |
| <a name="input_deletion_window_in_days"></a> [deletion\_window\_in\_days](#input\_deletion\_window\_in\_days) | Duration in days after which the key is deleted after destruction of the resource. | `number` | `7` | no |
| <a name="input_dns_record_name"></a> [dns\_record\_name](#input\_dns\_record\_name) | The name of the record. | `string` | `""` | no |
| <a name="input_egress_rule"></a> [egress\_rule](#input\_egress\_rule) | Enable to create egress rule | `bool` | `true` | no |
| <a name="input_enable"></a> [enable](#input\_enable) | Enable or disable of elasticache | `bool` | `true` | no |
| <a name="input_enable_key_rotation"></a> [enable\_key\_rotation](#input\_enable\_key\_rotation) | Specifies whether key rotation is enabled. | `string` | `true` | no |
| <a name="input_enable_security_group"></a> [enable\_security\_group](#input\_enable\_security\_group) | Enable default Security Group with only Egress traffic allowed. | `bool` | `true` | no |
| <a name="input_engine"></a> [engine](#input\_engine) | The name of the cache engine to be used for the clusters in this replication group. e.g. redis. | `string` | `""` | no |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | The version number of the cache engine to be used for the cache clusters in this replication group. | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | Additional tags (e.g. map(`BusinessUnit`,`XYZ`). | `map(string)` | `{}` | no |
| <a name="input_is_enabled"></a> [is\_enabled](#input\_is\_enabled) | Specifies whether the key is enabled. | `bool` | `true` | no |
| <a name="input_is_external"></a> [is\_external](#input\_is\_external) | enable to udated existing security Group | `bool` | `false` | no |
| <a name="input_key_usage"></a> [key\_usage](#input\_key\_usage) | Specifies the intended use of the key. Defaults to ENCRYPT\_DECRYPT, and only symmetric encryption and decryption are supported. | `string` | `"ENCRYPT_DECRYPT"` | no |
| <a name="input_kms_description"></a> [kms\_description](#input\_kms\_description) | The description of the key as viewed in AWS console. | `string` | `"Parameter Store KMS master key"` | no |
| <a name="input_kms_key_enabled"></a> [kms\_key\_enabled](#input\_kms\_key\_enabled) | Specifies whether the kms is enabled or disabled. | `bool` | `true` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | The ARN of the key that you wish to use if encrypting at rest. If not supplied, uses service managed encryption. Can be specified only if at\_rest\_encryption\_enabled = true. | `string` | `""` | no |
| <a name="input_kms_multi_region"></a> [kms\_multi\_region](#input\_kms\_multi\_region) | Indicates whether the KMS key is a multi-Region (true) or regional (false) key. | `bool` | `false` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | Label order, e.g. `name`,`application`. | `list(any)` | <pre>[<br>  "name",<br>  "environment"<br>]</pre> | no |
| <a name="input_length"></a> [length](#input\_length) | ##------------------------------- random\_password---------------------------- | `number` | `25` | no |
| <a name="input_log_delivery_configuration"></a> [log\_delivery\_configuration](#input\_log\_delivery\_configuration) | The log\_delivery\_configuration block allows the streaming of Redis SLOWLOG or Redis Engine Log to CloudWatch Logs or Kinesis Data Firehose. Max of 2 blocks. | `list(map(any))` | `[]` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | Maintenance window. | `string` | `"sun:05:00-sun:06:00"` | no |
| <a name="input_managedby"></a> [managedby](#input\_managedby) | ManagedBy, eg  'cypik'. | `string` | `"cypik"` | no |
| <a name="input_memcached_route53_record_enabled"></a> [memcached\_route53\_record\_enabled](#input\_memcached\_route53\_record\_enabled) | Whether to create Route53 record memcached set. | `bool` | `false` | no |
| <a name="input_memcached_ssm_parameter_endpoint_enabled"></a> [memcached\_ssm\_parameter\_endpoint\_enabled](#input\_memcached\_ssm\_parameter\_endpoint\_enabled) | Name of the parameter. | `bool` | `false` | no |
| <a name="input_multi_az_enabled"></a> [multi\_az\_enabled](#input\_multi\_az\_enabled) | Specifies whether to enable Multi-AZ Support for the replication group. If true, automatic\_failover\_enabled must also be enabled. Defaults to false. | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| <a name="input_node_type"></a> [node\_type](#input\_node\_type) | The compute and memory capacity of the nodes in the node group. | `string` | `"cache.t2.small"` | no |
| <a name="input_notification_topic_arn"></a> [notification\_topic\_arn](#input\_notification\_topic\_arn) | An Amazon Resource Name (ARN) of an SNS topic to send ElastiCache notifications to. | `string` | `""` | no |
| <a name="input_num_cache_clusters"></a> [num\_cache\_clusters](#input\_num\_cache\_clusters) | (Required for Cluster Mode Disabled) The number of cache clusters (primary and replicas) this replication group will have. If Multi-AZ is enabled, the value of this parameter must be at least 2. Updates will occur before other modifications. | `number` | `1` | no |
| <a name="input_num_cache_nodes"></a> [num\_cache\_nodes](#input\_num\_cache\_nodes) | (Required unless replication\_group\_id is provided) The initial number of cache nodes that the cache cluster will have. For Redis, this value must be 1. For Memcache, this value must be between 1 and 20. If this number is reduced on subsequent runs, the highest numbered nodes will be removed. | `number` | `1` | no |
| <a name="input_parameter_group_name"></a> [parameter\_group\_name](#input\_parameter\_group\_name) | The name of the parameter group to associate with this replication group. If this argument is omitted, the default cache parameter group for the specified engine is used. | `string` | `"default.redis5.0"` | no |
| <a name="input_port"></a> [port](#input\_port) | the port number on which each of the cache nodes will accept connections. | `string` | `""` | no |
| <a name="input_protocol"></a> [protocol](#input\_protocol) | The protocol. If not icmp, tcp, udp, or all use the. | `string` | `"tcp"` | no |
| <a name="input_replication_group_description"></a> [replication\_group\_description](#input\_replication\_group\_description) | Name of either the CloudWatch Logs LogGroup or Kinesis Data Firehose resource. | `string` | `"User-created description for the replication group."` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | Terraform current module repo | `string` | `"https://github.com/cypik/terraform-aws-elasticache"` | no |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | Specifies the number of days you want to retain log events in the specified log group. | `number` | `0` | no |
| <a name="input_route53_record_enabled"></a> [route53\_record\_enabled](#input\_route53\_record\_enabled) | Whether to create Route53 record set. | `bool` | `false` | no |
| <a name="input_route53_ttl"></a> [route53\_ttl](#input\_route53\_ttl) | (Required for non-alias records) The TTL of the record. | `string` | `""` | no |
| <a name="input_route53_type"></a> [route53\_type](#input\_route53\_type) | The record type. Valid values are A, AAAA, CAA, CNAME, MX, NAPTR, NS, PTR, SOA, SPF, SRV and TXT. | `string` | `""` | no |
| <a name="input_route53_zone_id"></a> [route53\_zone\_id](#input\_route53\_zone\_id) | Zone ID. | `string` | n/a | yes |
| <a name="input_security_group_names"></a> [security\_group\_names](#input\_security\_group\_names) | A list of cache security group names to associate with this replication group. | `list(string)` | `null` | no |
| <a name="input_sg_description"></a> [sg\_description](#input\_sg\_description) | The security group description. | `string` | `"Instance default security group (only egress access is allowed)."` | no |
| <a name="input_sg_egress_description"></a> [sg\_egress\_description](#input\_sg\_egress\_description) | Description of the egress and ingress rule | `string` | `"Description of the rule."` | no |
| <a name="input_sg_egress_ipv6_description"></a> [sg\_egress\_ipv6\_description](#input\_sg\_egress\_ipv6\_description) | Description of the egress\_ipv6 rule | `string` | `"Description of the rule."` | no |
| <a name="input_sg_ids"></a> [sg\_ids](#input\_sg\_ids) | of the security group id. | `list(any)` | `[]` | no |
| <a name="input_sg_ingress_description"></a> [sg\_ingress\_description](#input\_sg\_ingress\_description) | Description of the ingress rule | `string` | `"Description of the ingress rule use elasticache."` | no |
| <a name="input_snapshot_arns"></a> [snapshot\_arns](#input\_snapshot\_arns) | A single-element string list containing an Amazon Resource Name (ARN) of a Redis RDB snapshot file stored in Amazon S3. | `list(string)` | `null` | no |
| <a name="input_snapshot_name"></a> [snapshot\_name](#input\_snapshot\_name) | The name of a snapshot from which to restore data into the new node group. Changing the snapshot\_name forces a new resource. | `string` | `""` | no |
| <a name="input_snapshot_retention_limit"></a> [snapshot\_retention\_limit](#input\_snapshot\_retention\_limit) | (Redis only) The number of days for which ElastiCache will retain automatic cache cluster snapshots before deleting them. For example, if you set SnapshotRetentionLimit to 5, then a snapshot that was taken today will be retained for 5 days before being deleted. If the value of SnapshotRetentionLimit is set to zero (0), backups are turned off. Please note that setting a snapshot\_retention\_limit is not supported on cache.t1.micro or cache.t2.* cache nodes. | `string` | `"0"` | no |
| <a name="input_snapshot_window"></a> [snapshot\_window](#input\_snapshot\_window) | (Redis only) The daily time range (in UTC) during which ElastiCache will begin taking a daily snapshot of your cache cluster. The minimum snapshot window is a 60 minute period. | `string` | `null` | no |
| <a name="input_special"></a> [special](#input\_special) | n/a | `bool` | `false` | no |
| <a name="input_ssm_parameter_description"></a> [ssm\_parameter\_description](#input\_ssm\_parameter\_description) | SSM Parameters can be imported using. | `string` | `"Description of the parameter."` | no |
| <a name="input_ssm_parameter_endpoint_enabled"></a> [ssm\_parameter\_endpoint\_enabled](#input\_ssm\_parameter\_endpoint\_enabled) | Name of the parameter. | `bool` | `false` | no |
| <a name="input_ssm_parameter_type"></a> [ssm\_parameter\_type](#input\_ssm\_parameter\_type) | Type of the parameter. | `string` | `"SecureString"` | no |
| <a name="input_subnet_group_description"></a> [subnet\_group\_description](#input\_subnet\_group\_description) | Description for the cache subnet group. Defaults to `Managed by Terraform`. | `string` | `"The Description of the ElastiCache Subnet Group."` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | List of VPC Subnet IDs for the cache subnet group. | `list(any)` | `[]` | no |
| <a name="input_transit_encryption_enabled"></a> [transit\_encryption\_enabled](#input\_transit\_encryption\_enabled) | Whether to enable encryption in transit. | `bool` | `true` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC that the instance security group belongs to. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_Memcached_ssm_name"></a> [Memcached\_ssm\_name](#output\_Memcached\_ssm\_name) | A list of all of the parameter values |
| <a name="output_auth_token"></a> [auth\_token](#output\_auth\_token) | Auth token generated value |
| <a name="output_hostname"></a> [hostname](#output\_hostname) | DNS hostname |
| <a name="output_id"></a> [id](#output\_id) | Redis cluster id. |
| <a name="output_memcached_arn"></a> [memcached\_arn](#output\_memcached\_arn) | Memcached arn |
| <a name="output_memcached_endpoint"></a> [memcached\_endpoint](#output\_memcached\_endpoint) | Memcached endpoint address. |
| <a name="output_memcached_hostname"></a> [memcached\_hostname](#output\_memcached\_hostname) | DNS hostname |
| <a name="output_port"></a> [port](#output\_port) | Redis port. |
| <a name="output_redis_arn"></a> [redis\_arn](#output\_redis\_arn) | Redis arn |
| <a name="output_redis_endpoint"></a> [redis\_endpoint](#output\_redis\_endpoint) | Redis endpoint address. |
| <a name="output_redis_ssm_name"></a> [redis\_ssm\_name](#output\_redis\_ssm\_name) | A list of all of the parameter values |
| <a name="output_sg_id"></a> [sg\_id](#output\_sg\_id) | n/a |
| <a name="output_tags"></a> [tags](#output\_tags) | A mapping of tags to assign to the resource. |
<!-- END_TF_DOCS -->