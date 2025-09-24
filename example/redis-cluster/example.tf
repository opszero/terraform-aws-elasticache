provider "aws" {
  region = "eu-west-1"
}

module "vpc" {
  source     = "git@github.com:opszero/terraform-aws-vpc?ref=v1.0.1"
  name       = "test"
  cidr_block = "10.0.0.0/16"
}

module "subnets" {
  source             = "git@github.com:opszero/terraform-aws-subnets?ref=v1.0.0"
  name               = "subnets"
  availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  vpc_id             = module.vpc.vpc_id
  type               = "public"
  igw_id             = module.vpc.igw_id
  cidr_block         = module.vpc.vpc_cidr_block
  ipv6_cidr_block    = module.vpc.ipv6_cidr_block
}

module "redis-cluster" {
  source = "./../../"
  name   = "redis-cluster"
  vpc_id = module.vpc.vpc_id

  engine                        = "redis"
  engine_version                = "7.0"
  port                          = 6379
  node_type                     = "cache.t2.micro"
  subnet_ids                    = module.subnets.public_subnet_id
  availability_zones            = ["eu-west-1a", "eu-west-1b"]
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
