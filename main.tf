provider "aws" {
  region = var.region
}

module "vpc" {
  source      = "./vpc"
  environment = var.environment
}

module "security" {
  source = "./security"
  vpc_id = module.vpc.vpc_id
}

module "ec2" {
  source         = "./ec2"
  subnet_id      = module.vpc.private_subnet_id
  sg_id          = module.security.ec2_sg_id
  instance_type  = var.instance_type
  key_name       = aws_key_pair.generated_key.key_name
}

module "alb" {
  source           = "./alb"
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_sg_id        = module.security.alb_sg_id
  vpc_id           = module.vpc.vpc_id
  instance_id      = module.ec2.instance_id
}

resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "strapi-key"
  public_key = tls_private_key.ec2_key.public_key_openssh
}

resource "local_file" "pem_file" {
  filename        = "strapi-key.pem"
  content         = tls_private_key.ec2_key.private_key_pem
  file_permission = "0400"
}

