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

module "control_plane_iam_roles" {
  source = "./ec2/iam_role/control_plane_iam_role"
}

module "worker_node_iam_roles" {
  source = "./ec2/iam_role/worker_node_iam_role"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}


resource "aws_instance" "control_plane" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t3.medium"
  subnet_id = module.vpc.public_subnets[0]
  iam_instance_profile = module.control_plane_iam_roles.control_plane_instance_profile_name
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }
  tags = {
    Name = "tf-lidor_control_plane_projectf"
    Environment = var.env
    Region = var.region
  }
}

resource "aws_instance" "worker_node" {
  ami = data.aws_ami.ubuntu.id
  instance_type = "t3.medium"
  subnet_id = module.vpc.public_subnets[1]
  iam_instance_profile = module.worker_node_iam_roles.worker_node_instance_profile_name
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }
  tags = {
    Name = "tf-lidor_control_plane_projectf"
    Environment = var.env
    Region = var.region
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.19.0"
  name = "lidor_project_vpc_tf"
  cidr = "10.0.0.0/16"

  azs             = var.vpc_azs
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.3.0/24", "10.0.4.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false
  map_public_ip_on_launch = true

  tags = {
    Terraform = "true"
    Environment = var.env
  }
}

