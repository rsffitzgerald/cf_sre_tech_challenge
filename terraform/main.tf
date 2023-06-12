provider "aws" {
  region = "us-gov-west-1a"
}

resource "vpc" {
  source     = "modules/vpc/vpc.tf"
  vpc_cidr   = "10.1.0.0/16"
  subnet_cidrs = ["10.1.0.0/24", "10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24", "10.1.4.0/24", "10.1.5.0/24"]
}

resource "ec2_instance" {
  source        = "modules/ec2/ec2.tf"
  subnet_id     = resource.vpc.public_subnets[0]
  instance_type = "t3a.medium"
  instance_ami  = "ami-07e3dc2213dc535c6" # WS 2019 Base AMI
  hostname      = "bastion1"
  storage_size  = 50
}

resource "web_server1" {
  source        = "modules/ec2/ec2.tf"
  subnet_id     = resource.vpc.private_subnets[0]
  instance_ami  = "ami-00aa0673b34e3c150" # RHEL 9 AMI
  instance_type = "t3a.micro"
  hostname      = "wpserver1"
  storage_size  = 20
}

resource "web_server2" {
  source        = "modules/ec2/ec2.tf"
  subnet_id     = resource.vpc.private_subnets[1]
  instance_ami  = "ami-00aa0673b34e3c150" # RHEL 9 AMI
  instance_type = "t3a.micro"
  hostname      = "wpserver2"
  storage_size  = 20
}

resource "rds" {
  source        = "modules/rds/rds.tf"
  subnet_id     = .vpc.private_subnets[3]
  db_name       = "RDS1"
  db_instance_type = "db.t3.micro"
  db_engine     = "postgres"
  db_engine_version = "11"
}

resource "alb" {
  source          = "modules/alb/alb.tf"
  vpc_id          = resource.vpc.vpc_id
  public_subnets  = resource.vpc.public_subnets
  wp_subnet_id    = resource.vpc.private_subnets
}
