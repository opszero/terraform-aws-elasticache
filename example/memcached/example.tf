provider "aws" {
  region = "eu-west-1"
}

module "vpc" {
  source      = "git::https://github.com/cypik/terraform-aws-vpc.git?ref=v1.0.0"
  name        = "vpc"
  environment = "test"
  label_order = ["environment", "name"]
  cidr_block  = "10.0.0.0/16"
}

module "subnets" {
  source             = "git::https://github.com/cypik/terraform-aws-subnet.git?ref=v1.0.0"
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

module "memcached" {
  source        = "./../../"
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
