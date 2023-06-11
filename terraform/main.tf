provider "aws" {
  region = "us-gov-west-1"
}

module "vpc" {
  source     = "modules/vpc/main.tf"
  vpc_cidr   = "10.1.0.0/16"
  subnet_cidrs = ["10.1.0.0/24", "10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24", "10.1.4.0/24", "10.1.5.0/24"]
}

module "ec2_instance" {
  source        = "modules/ec2/main.tf"
  subnet_id     = module.vpc.public_subnet_ids[0]
  instance_type = "t3a.medium"
  instance_ami  = "ami-07e3dc2213dc535c6" # WS 2019 Base AMI
  hostname      = "bastion1"
  storage_size  = 50
}

module "web_server_1" {
  source        = "modules/ec2/main.tf"
  subnet_id     = module.vpc.wp_subnet_ids[0]
  instance_ami  = "ami-00aa0673b34e3c150" # RHEL 9 AMI
  instance_type = "t3a.micro"
  hostname      = "wpserver1"
  storage_size  = 20
}

module "web_server_2" {
  source        = "modules/ec2/main.tf"
  subnet_id     = module.vpc.wp_subnet_ids[1]
  instance_ami  = "ami-00aa0673b34e3c150" # RHEL 9 AMI
  instance_type = "t3a.micro"
  hostname      = "wpserver2"
  storage_size  = 20
}

module "rds" {
  source        = "modules/rds/main.tf"
  subnet_id     = module.vpc.db_subnet_ids[1]
  db_name       = "RDS1"
  db_instance_type = "db.t3.micro"
  db_engine     = "postgres"
  db_engine_version = "11"
}

module "alb" {
  source          = "modules/alb/main.tf"
  vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnet_ids
  wp_subnet_id    = module.vpc.wp_subnet_ids[0]
}

