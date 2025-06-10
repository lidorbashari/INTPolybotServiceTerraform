terraform {
  required_version = ">= 1.7.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.55"
    }
  }

  backend "s3" {
    bucket = "lidor-project-bucket-tf"
    key    = "tfstate.json"
    region = "eu-north-1"
  }
}

provider "aws" {
  region = var.region
}


module "control_plane_module" {
  source    = "./.terraform/modules/ec2_control_plane"
  ami_id    = data.aws_ami.ubuntu.id
  vpc_id    = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnets[0]
  env       = var.env
  region    = var.region
  key_name = aws_key_pair.polybot.key_name
}

module "worker_node_module" {
  source    = "./.terraform/modules/ec2_worker_node"
  ami_id    = data.aws_ami.ubuntu.id
  vpc_id    = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnets[1]
  env       = var.env
  region    = var.region
  key_name = aws_key_pair.polybot.key_name
  depends_on = [module.control_plane_module]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"
  name    = "lidor_project_vpc_tf"
  cidr    = "10.0.0.0/16"

  azs             = var.vpc_azs
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]

  enable_nat_gateway      = false
  enable_vpn_gateway      = false
  map_public_ip_on_launch = true

  tags = {
    Terraform   = "true"
    Environment = var.env
  }
}

resource "aws_key_pair" "polybot" {
  key_name   = "polybot-key2"
  public_key = file("${path.module}/keys/polybot-key.pub")
}

module "polybot_resources" {
  source = "./.terraform/modules/polybot"
  env    = var.env
  region = var.region
}

resource "aws_secretsmanager_secret" "telegram_bot" {
  name = "lidor-telegram-tf-token"
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_secretsmanager_secret_version" "telegram_bot_version" {
  secret_id     = aws_secretsmanager_secret.telegram_bot.id
  secret_string = jsonencode({
    TELEGRAM_BOT_TOKEN = var.telegram_token
  })
}