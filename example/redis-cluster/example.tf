provider "aws" {
  region = "eu-west-1"
}

module "vpc" {
  source      = "cypik/vpc/aws"
  version     = "1.0.1"
  name        = "redis2"
  environment = "test"
  label_order = ["environment", "name"]
  cidr_block  = "10.0.0.0/16"
}

module "subnets" {
  source             = "cypik/subnet/aws"
  version            = "1.0.1"
  name               = "subnets"
  environment        = "test"
  label_order        = ["environment", "name"]
  availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  vpc_id             = module.vpc.id
  type               = "public"
  igw_id             = module.vpc.igw_id
  cidr_block         = module.vpc.vpc_cidr_block
  ipv6_cidr_block    = module.vpc.ipv6_cidr_block
}

module "redis-cluster" {
  source        = "./../../"
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
