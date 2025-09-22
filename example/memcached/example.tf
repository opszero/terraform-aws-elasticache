provider "aws" {
  region = "eu-west-1"
}

module "vpc" {
  source     = "git@github.com:opszero/terraform-aws-vpc?ref=v1.0.0"
  name       = "test"
  cidr_block = "10.0.0.0/16"
}

module "subnets" {
  source             = "git@github.com:opszero/terraform-aws-subnets?ref=main"
  name               = "subnets"
  availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  vpc_id             = module.vpc.vpc_id
  type               = "public"
  igw_id             = module.vpc.igw_id
  cidr_block         = module.vpc.vpc_cidr_block
  ipv6_cidr_block    = module.vpc.ipv6_cidr_block
}

module "memcached" {
  source = "./../../"
  name   = "memcached"
  vpc_id = module.vpc.vpc_id

  engine                     = "memcached"
  engine_version             = "1.6.17"
  node_type                  = "cache.t2.micro"
  num_cache_nodes            = 2
  subnet_ids                 = module.subnets.public_subnet_id
  availability_zones         = ["eu-west-1a", "eu-west-1b"]
  automatic_failover_enabled = false
  security_group_ids         = []
  security_group_names       = null

}
