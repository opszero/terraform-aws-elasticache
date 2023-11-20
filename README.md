# Terraform-aws-elasticache

# AWS Infrastructure Provisioning with Terraform

## Table of Contents
- [Introduction](#introduction)
- [Usage](#usage)
- [Module Inputs](#module-inputs)
- [Module Outputs](#module-outputs)
- [License](#license)

## Introduction
This module is basically combination of Terraform open source and includes automatation tests and examples. It also helps to create and improve your infrastructure with minimalistic code instead of maintaining the whole infrastructure code yourself.
## Usage
To use this module, you can include it in your Terraform configuration. Here's an example of how to use it:

## Examples

## Example: memcached

```hcl
module "memcached" {
  source      = "git::https://github.com/opz0/terraform-aws-memcached.git?ref=v1.0.0"
  name        = "memcached"
  environment = "test"
  label_order = ["name", "environment"]

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
    Application = "opz0"
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
  source      = "git::https://github.com/opz0/terraform-aws-redis.git?ref=v1.0.0"
  name        = "redis"
  environment = "test"
  label_order = ["name", "environment"]

  vpc_id        = module.vpc.id
  allowed_ip    = [module.vpc.vpc_cidr_block]
  allowed_ports = [6379]

  cluster_replication_enabled = true
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
    Application = "Opz0"
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
  source      = "git::https://github.com/opz0/terraform-aws-redis-cluster.git?ref=v1.0.0"
  name        = "redis-cluster"
  environment = "test"
  label_order = ["environment", "name"]


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
    Application = "Opz0"
  }

  route53_record_enabled         = false
  ssm_parameter_endpoint_enabled = false
  dns_record_name                = "prod"
  route53_ttl                    = "300"
  route53_type                   = "CNAME"
  route53_zone_id                = "SERFxxxx6XCsY9Lxxxxx"
}
```

## Module Inputs
- `name`: A name for your application.
- `parameter_group_name`: Name of the parameter group to associate with this cache cluster
- `az_mode`: Specifies whether the nodes in this Memcached node group are created in a single Availability Zone or created across multiple Availability Zones in the cluster's region.
- `engine_version`: Version number of the cache engine to be used.
- `node_type`: The compute and memory capacity of the nodes. See Available Cache Node Types for supported node types.
- For security group settings, you can configure the ingress and egress rules using variables like:

## Module Outputs
- `id`  : The ElastiCache parameter group name.
- `tags`: A map of tags to assign to the resource
- Other relevant security group outputs (modify as needed).

## Examples
For detailed examples on how to use this module, please refer to the 'examples' directory within this repository.

## Author
Your Name Replace '[License Name]' and '[Your Name]' with the appropriate license and your information. Feel free to expand this README with additional details or usage instructions as needed for your specific use case.

## License
This project is licensed under the MIT License - see the [LICENSE](https://github.com/opz0/terraform-aws-elasticache/blob/master/LICENSE) file for details.
